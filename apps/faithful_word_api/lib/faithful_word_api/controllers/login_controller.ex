defmodule FaithfulWordApi.LoginController do
  import FaithfulWord.Mailer

  use FaithfulWordApi, :controller

  alias FaithfulWord.Accounts
  alias FaithfulWord.Accounts.Admin
  alias FaithfulWordApi.Guardian

  # require Ecto.Query
  # require Logger

  plug :scrub_params, "signup" when action in [:create]

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"signup" => auth_params}) do
    with {:ok, email} <- Map.fetch(auth_params, "email"),
         {:ok, password} <- Map.fetch(auth_params, "password"),
         {:ok, user} <- Accounts.authenticate(email, password) do
      conn
      # |> Guardian.Plug.sign_in(user)
        |> put_flash(:info, gettext("%{user_email} already exists.", user_email: user.email))
        |> redirect(to: Routes.page_path(conn, :index))
    else
      _ ->
        conn
        |> put_flash(:info, gettext("Please check your email for your confirmation link."))
        |> redirect(to: Routes.page_path(conn, :index))
    end
  end
end
