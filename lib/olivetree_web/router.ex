defmodule OlivetreeWeb.Router do
  use OlivetreeWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", OlivetreeWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/about", PageController, :about
    get "/login", AuthController, :show_login
    post "/login", AuthController, :do_login
    get "/register", AuthController, :show_register
    post "/register", AuthController, :do_register

  end

  # Other scopes may use custom stacks.
  # scope "/api", OlivetreeWeb do
  #   pipe_through :api
  # end
end
