defmodule FaithfulWordApi.Router do
  use FaithfulWordApi, :router
  alias FaithfulWord.Authenticator.GuardianImpl

  # ---- Pipelines ----

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers

    plug FaithfulWordApi.Auth.Web.GuardianPipeline
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :api_auth do
    # plug(FaithfulWordApi.Auth.Pipeline)
    plug(GuardianImpl.Pipeline)
    plug(Guardian.Plug.VerifyHeader, realm: "Bearer")
    plug(Guardian.Plug.LoadResource, allow_blank: true)
  end

  # -------- Routes --------

  scope "/", FaithfulWordApi do

    # ---- Browser ----

    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/about", PageController, :about
    get "/login", LoginController, :new
    post "/login", LoginController, :create
    # get "/login", AuthController, :new
    # post "/login", AuthController, :create

    get "/signup", SignupController, :new
    post "/signup", SignupController, :create
  end

  pipeline :authentication_required do
    plug Guardian.Plug.EnsureAuthenticated
  end

  scope "/", FaithfulWordApi do
    # Use the default browser stack
    pipe_through [:browser, :authentication_required]
    get "/logout", LoginController, :destroy
  end

  # ---- Public endpoints ----

  scope "/v1.3", FaithfulWordApi do
    pipe_through(:api)

    get "/books", BookController, :index
    # post("/sessions", SessionController, :create)
    # post("/users", UserController, :create)

    # post("/sessions", SessionController, :create)
    # post("/users", UserController, :create)
  end

  # ---- Authenticathed endpoints ----

  scope "/" do
    pipe_through([:api_auth])

    # Authentication
    scope "/auth" do
      delete("/", AuthController, :logout)
      delete("/:provider/link", AuthController, :unlink_provider)
      post("/:provider/callback", AuthController, :callback)
    end
  end
end
