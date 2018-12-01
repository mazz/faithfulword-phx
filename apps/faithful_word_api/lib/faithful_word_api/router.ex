defmodule FaithfulWordApi.Router do
  use FaithfulWordApi, :router

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
    plug(FaithfulWordApi.Auth.Pipeline)
  end

  scope "/", FaithfulWordApi do
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

  scope "/v1.3", FaithfulWordApi do
    pipe_through(:api)

    get "/books", BookController, :index
    # post("/sessions", SessionController, :create)
    # post("/users", UserController, :create)

    # post("/sessions", SessionController, :create)
    # post("/users", UserController, :create)
  end

  scope "/apiauth", FaithfulWordApi do
    pipe_through(:api)
    post("/sessions", SessionController, :create)
    post("/users", UserController, :create)
  end

  scope "/apiauth", FaithfulWordApi do
    pipe_through([:api, :api_auth])

    delete("/sessions", SessionController, :delete)
    post("/sessions/refresh", SessionController, :refresh)
  end

  scope "/", FaithfulWordApi do
    # Use the default browser stack
    pipe_through [:browser, :authentication_required]
    get "/logout", LoginController, :destroy

    # scope "/admin", Admin, as: :admin do
    #   get "/offers/published", OfferController, :index_published
    #   get "/offers/pending", OfferController, :index_unpublished
    #   get "/offers/:slug/publish", OfferController, :publish
    #   get "/offers/:slug/send_twitter", OfferController, :send_twitter
    #   get "/offers/:slug/send_telegram", OfferController, :send_telegram
    #   get "/offers/:slug/edit", OfferController, :edit
    #   put "/offers/:slug/edit", OfferController, :update
    #   delete "/offers/:slug", OfferController, :delete
    # end
  # Other scopes may use custom stacks.
  # scope "/api", FaithfulWordApi do
  #   pipe_through :api
  end
end
