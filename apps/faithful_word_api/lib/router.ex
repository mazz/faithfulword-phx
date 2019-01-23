defmodule FaithfulWordApi.Router do
  use FaithfulWordApi, :router
  alias FaithfulWord.Authenticator.GuardianImpl


  # ---- Pipelines ----

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :api_auth do
    plug(GuardianImpl.Pipeline)
    plug(Guardian.Plug.VerifyHeader, realm: "Bearer")
    plug(Guardian.Plug.LoadResource, allow_blank: true)
  end

  # -------- Routes --------

  scope "/", FaithfulWordApi do
    pipe_through([:api])

    # ---- Public endpoints ----
    # get("/", ApiInfoController, :get)
    # get("/videos", VideoController, :index)
    # get("/speakers/:slug_or_id", SpeakerController, :show)
    # post("/search/video", VideoController, :search)
    # get("/videos/:video_id/statements", StatementController, :get)
    # get("/newsletter/unsubscribe/:token", UserController, :newsletter_unsubscribe)

    # ---- Authenticathed endpoints ----
    scope "/" do
      pipe_through([:api_auth])

      # Authentication
      scope "/auth" do
        delete("/", AuthController, :logout)
        delete("/:provider/link", AuthController, :unlink_provider)
        post("/:provider/callback", AuthController, :callback)
      end

      # Users
      scope "/users" do
        post("/", UserController, :create)
        post("/request_invitation", UserController, :request_invitation)
        get("/username/:username", UserController, :show)

        scope "/reset_password" do
          post("/request", UserController, :reset_password_request)
          get("/verify/:token", UserController, :reset_password_verify)
          post("/confirm", UserController, :reset_password_confirm)
        end

        scope "/me" do
          get("/", UserController, :show_me)
          put("/", UserController, :update)
          delete("/", UserController, :delete)
          get("/available_flags", UserController, :available_flags)
          put("/confirm_email/:token", UserController, :confirm_email)
          put("/achievements/:achievement", UserController, :unlock_achievement)
          post("/onboarding/complete_step", UserController, :complete_onboarding_step)
          post("/onboarding/complete_steps", UserController, :complete_onboarding_steps)
          delete("/onboarding", UserController, :delete_onboarding)
        end
      end

      # Videos
      post("/videos", VideoController, :get_or_create)

      # Moderation
      get("/moderation/random", ModerationController, :random)
      post("/moderation/feedback", ModerationController, :post_feedback)
    end




  defp handle_errors(conn, %{kind: kind, reason: reason, stack: stacktrace}) do
    conn =
      conn
      |> Plug.Conn.fetch_cookies()
      |> Plug.Conn.fetch_query_params()

    params =
      case conn.params do
        %Plug.Conn.Unfetched{aspect: :params} -> "unfetched"
        other -> other
      end

    occurrence_data = %{
      "request" => %{
        "cookies" => conn.req_cookies,
        "url" => "#{conn.scheme}://#{conn.host}:#{conn.port}#{conn.request_path}",
        "user_ip" => List.to_string(:inet.ntoa(conn.remote_ip)),
        "headers" => filter_headers(conn),
        "method" => conn.method,
        "params" => filter_params(params)
      }
    }

    FaithfulWord.Errors.do_report(kind, reason, stacktrace, data: occurrence_data)
  end

  defp filter_headers(conn) do
    for {key, value} = tuple <- conn.req_headers, into: %{} do
      case key do
        "authorization" ->
          {key, filter_str(value, 16)}

        _ ->
          tuple
      end
    end
  end

  defp filter_params(params) when is_map(params) do
    for {key, value} = tuple <- params, into: %{} do
      case key do
        k when k in ~w(password passwordRepeat) ->
          {key, filter_str(value)}

        "user" when is_map(value) ->
          {key, filter_params(value)}

        _ ->
          tuple
      end
    end
  end

  defp filter_params(params), do: params

  def filter_str(str, length_to_keep \\ 0) do
    "#{String.slice(str, 0, length_to_keep)}********* [FILTERED]"
  end

  # ---- Dev only: mailer. We can use Mix.env here cause file is interpreted at compile time ----
  if Mix.env() == :dev do
    pipeline :browser do
      plug(:accepts, ["html"])
    end

    scope "/_dev/" do
      pipe_through([:browser])
      forward("/mail", Bamboo.SentEmailViewerPlug)
    end
  end


  end

  # ---- Pipelines ----

  # pipeline :browser do
  #   plug :accepts, ["html"]
  #   plug :fetch_session
  #   plug :fetch_flash
  #   plug :protect_from_forgery
  #   plug :put_secure_browser_headers

  #   plug FaithfulWordApi.Auth.Web.GuardianPipeline
  # end

  # pipeline :api do
  #   plug :accepts, ["json"]
  # end

  # pipeline :api_auth do
  #   # plug(FaithfulWordApi.Auth.Pipeline)
  #   plug(GuardianImpl.Pipeline)
  #   plug(Guardian.Plug.VerifyHeader, realm: "Bearer")
  #   plug(Guardian.Plug.LoadResource, allow_blank: true)
  # end

  # # -------- Routes --------

  # scope "/", FaithfulWordApi do

  #   # ---- Browser ----

  #   pipe_through :browser # Use the default browser stack

  #   get "/", PageController, :index
  #   get "/about", PageController, :about
  #   get "/login", LoginController, :new
  #   post "/login", LoginController, :create
  #   # get "/login", AuthController, :new
  #   # post "/login", AuthController, :create

  #   get "/signup", SignupController, :new
  #   post "/signup", SignupController, :create
  # end

  # # -------- Routes --------

  # scope "/", FaithfulWordApi do
  #   pipe_through([:api])

  #   # ---- Public endpoints ----
  #   # get("/", ApiInfoController, :get)
  #   get("/videos", VideoController, :index)
  #   # get("/speakers/:slug_or_id", SpeakerController, :show)
  #   # post("/search/video", VideoController, :search)
  #   # get("/videos/:video_id/statements", StatementController, :get)
  #   # get("/newsletter/unsubscribe/:token", UserController, :newsletter_unsubscribe)
  # end

  # # ---- Authenticathed endpoints ----
  # scope "/", FaithfulWordApi do
  #   pipe_through([:api_auth])

  #   # Authentication
  #   scope "/auth" do
  #     delete("/", AuthController, :logout)
  #     delete("/:provider/link", AuthController, :unlink_provider)
  #     post("/:provider/callback", AuthController, :callback)
  #   end

  #   # # Users
  #   scope "/users" do
  #     post("/", UserController, :create)
  #     post("/request_invitation", UserController, :request_invitation)
  #     get("/username/:username", UserController, :show)

  #     scope "/reset_password" do
  #       post("/request", UserController, :reset_password_request)
  #       get("/verify/:token", UserController, :reset_password_verify)
  #       post("/confirm", UserController, :reset_password_confirm)
  #     end

  #     scope "/me" do
  #       get("/", UserController, :show_me)
  #       put("/", UserController, :update)
  #       delete("/", UserController, :delete)
  #       get("/available_flags", UserController, :available_flags)
  #       put("/confirm_email/:token", UserController, :confirm_email)
  #       put("/achievements/:achievement", UserController, :unlock_achievement)
  #       post("/onboarding/complete_step", UserController, :complete_onboarding_step)
  #       post("/onboarding/complete_steps", UserController, :complete_onboarding_steps)
  #       delete("/onboarding", UserController, :delete_onboarding)
  #     end
  #   end

  #   # # Videos
  #   # post("/videos", VideoController, :get_or_create)

  #   # # Moderation
  #   # get("/moderation/random", ModerationController, :random)
  #   # post("/moderation/feedback", ModerationController, :post_feedback)
  # end

  # pipeline :authentication_required do
  #   plug Guardian.Plug.EnsureAuthenticated
  # end

  # scope "/", FaithfulWordApi do
  #   # Use the default browser stack
  #   pipe_through [:browser, :authentication_required]
  #   get "/logout", LoginController, :destroy
  # end

  # # ---- Public endpoints ----

  # scope "/v1.3", FaithfulWordApi do
  #   pipe_through(:api)

  #   get "/books", BookController, :index
  #   # post("/sessions", SessionController, :create)
  #   # post("/users", UserController, :create)

  #   # post("/sessions", SessionController, :create)
  #   # post("/users", UserController, :create)
  # end

  # ---- Authenticathed endpoints ----

  # scope "/" do
  #   pipe_through([:api_auth])

  #   # Authentication
  #   scope "/auth" do
  #     delete("/", AuthController, :logout)
  #     delete("/:provider/link", AuthController, :unlink_provider)
  #     post("/:provider/callback", AuthController, :callback)
  #   end
  # end



end