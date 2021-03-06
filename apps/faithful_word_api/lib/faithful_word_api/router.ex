defmodule FaithfulWordApi.Router do
  use FaithfulWordApi, :router
  alias FaithfulWord.Authenticator.GuardianImpl
  import Phoenix.LiveDashboard.Router
  import Plug.BasicAuth

  # ---- Pipelines ----
  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_layout, {FaithfulWordApi.LayoutView, :app}
    plug FaithfulWordApi.Plugs.GuardianPipeline
  end

  pipeline :authentication_required do
    plug Guardian.Plug.EnsureAuthenticated
  end

  pipeline :admins_only do
    plug :basic_auth, username: "admin", password: "admin"
  end

  scope "/" do
    pipe_through [:browser, :admins_only]
    live_dashboard "/dashboard", metrics: FaithfulWordApi.Telemetry
  end

  if Mix.env() == :dev do
    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: FaithfulWordApi.Telemetry
    end
  end

  scope "/", FaithfulWordApi do
    # Use the default browser stack
    pipe_through :browser

    get "/", PageController, :index
    get "/m/:hash_id", ShareMediaItemController, :show

    # get "/about", PageController, :about
    # get "/login", LoginController, :new
    # # get "/logout", LoginController, :delete
    # post "/login", LoginController, :create
    # get "/signup", SignupController, :new
    # post "/signup", SignupController, :create
    # # get "/login/:magic_token", LoginController, :callback
  end

  scope "/", FaithfulWordApi do
    pipe_through [:browser, :authentication_required]

    # get "/logout", LoginController, :delete

    # scope "/admin", Admin do
    # scope "/admin", Admin, as: :admin do
    # get "/notification/send", PushMessageController, :index
    # get "/upload", UploadController, :index
    # end
  end

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

    scope "/v1.2" do
      scope "/books" do
        get "/", BookController, :indexv12
        get "/:bid/media", MediaChapterController, :indexv12
      end

      scope "/gospels" do
        get "/", GospelController, :indexv12
        get "/:gid/media", MediaGospelController, :indexv12
      end

      scope "/music" do
        get "/", MusicController, :indexv12
        get "/:mid/media", MediaMusicController, :indexv12
      end

      scope "/languages" do
        get "/supported", LanguageIdentifierController, :indexv12
      end

      scope "/app" do
        get "/versions", AppVersionController, :indexv12
      end

      scope "/device" do
        post "/pushtoken/update", ClientDeviceController, :indexv12
      end
    end

    # prefix public api with /api for v1.3 and above

    scope "/api" do
      scope "/v1.3" do
        scope "/books" do
          get "/", BookController, :indexv13
          get "/:uuid/media", MediaChapterController, :indexv13
        end

        scope "/orgs" do
          get "/", OrgController, :indexv13
          get "/default", OrgController, :defaultv13
          get "/:uuid/channels", OrgController, :channelsv13
        end

        scope "/channels" do
          # post "/add", ChannelController, :addv13
          get "/:uuid/playlists", PlaylistController, :indexv13
        end

        scope "/playlists" do
          get "/:uuid/details", PlaylistController, :detailsv13
        end

        scope "/playlists" do
          # post "/add", PlaylistController, :addv13
          get "/:uuid/media", MediaItemController, :indexv13
        end

        scope "/mediaitem" do
          get "/:uuid/details", MediaItemController, :detailsv13
        end

        scope "/mediaitem" do
          get "/:hashId/detailshashid", MediaItemController, :detailshashidv13
        end

        scope "/search" do
          post "/", SearchController, :searchv13
        end

        scope "/device" do
          post "/pushtoken/update", ClientDeviceController, :indexv13
        end

        ### DEPRECATED ###
        scope "/gospels" do
          get "/", GospelController, :indexv13
          get "/:uuid/media", MediaGospelController, :indexv13
        end

        scope "/music" do
          get "/", MusicController, :indexv13
          get "/:uuid/media", MediaMusicController, :indexv13
        end

        scope "/languages" do
          get "/supported", LanguageIdentifierController, :indexv13
        end

        scope "/app" do
          get "/versions", AppVersionController, :indexv13
        end
      end
    end
  end

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
      scope "/api" do
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
        end

        scope "/user" do
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
      scope "/api" do
        scope "/v1.3" do
          post("/videos", VideoController, :get_or_create)
        end
      end

      # v1.3 non-public content api
      scope "/api" do
        scope "/v1.3" do
          scope "/pushmessages" do
            post "/addorupdate", PushMessageController, :add_or_update_v13
            post "/send", PushMessageController, :send
          end

          scope "/orgs" do
            post "/addorupdate", OrgController, :add_or_update_v13
            post "/delete", OrgController, :delete_v13
          end

          scope "/channels" do
            post "/addorupdate", ChannelController, :add_or_update_v13
            post "/delete", ChannelController, :delete_v13
          end

          scope "/playlisttitles" do
            post "/delete", PlaylistTitleController, :delete_v13
          end

          scope "/playlists" do
            post "/addorupdate", PlaylistController, :add_or_update_v13
            post "/delete", PlaylistController, :delete_v13
          end

          scope "/mediaitems" do
            post "/addorupdate", MediaItemController, :add_or_update_v13
            post "/delete", MediaItemController, :delete_v13
            # get "/:uuid/media", MediaItemController, :indexv13
          end
        end
      end

      # Moderation
      scope "/api" do
        get("/moderation/random", ModerationController, :random)
        post("/moderation/feedback", ModerationController, :post_feedback)
      end
    end

    # end

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
end
