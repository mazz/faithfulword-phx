defmodule FaithfulWordApi.LoginController do
  import FaithfulWord.Mailer

  use FaithfulWordApi, :controller

  alias FaithfulWord.Accounts
  alias FaithfulWord.Authenticator.GuardianImpl
  alias FaithfulWordApi.Guardian
  alias FaithfulWord.Authenticator
  alias DB.Schema.User

  alias Phoenix.LiveView

  alias Kaur.Result
  # require Ecto.Query
  # require Logger

  plug :scrub_params, "login" when action in [:create]

  def index(conn, _params) do
    conn
    # |> Guardian.Plug.sign_in(user)
    |> put_flash(:info, gettext("login successful 2"))

    # render(conn, "new.html")
    # LiveView.Controller.live_render(conn, FaithfulWordApi.GithubDeployView, session: %{})
  end

  def new(conn, _params) do
    render(conn, "new.html")
    # LiveView.Controller.live_render(conn, FaithfulWordApi.GithubDeployView, session: %{})
  end

  def create(conn, %{"login" => login_params}) do
    {:ok, email} = Map.fetch(login_params, "email")
    {:ok, password} = Map.fetch(login_params, "password")

    case Authenticator.get_user_for_email_or_name_password(email, password) do
      nil ->
        conn
        |> put_flash(:error, "Invalid credentials!")
        |> render("new.html")

      user ->
        conn
        |> Guardian.Plug.sign_in(user)
        |> put_flash(:info, gettext("Welcome %{user_name}!", user_name: user.name))
        # |> render("home.html")
        |> redirect(to: Routes.page_path(conn, :index))

        # # |> Guardian.Plug.sign_in(user)
        # |> GuardianImpl.Plug.sign_in(user)
        # |> render("home.html")
    end
  end

  def delete(conn, _params) do
    conn
    |> GuardianImpl.Plug.sign_out()
    |> put_flash(:info, gettext("Successfully logged out! See you!"))
    |> redirect(to: Routes.login_path(conn, :new))
  end

  def auth_error(conn, {_type, _reason}, _opts) do
    conn
    |> put_flash(:error, gettext("Authentication required"))
    |> redirect(to: Routes.login_path(conn, :new))
  end
end
