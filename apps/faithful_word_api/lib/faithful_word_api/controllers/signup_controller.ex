defmodule FaithfulWordApi.SignupController do
  import FaithfulWord.Mailer

  use FaithfulWordApi, :controller

  alias FaithfulWord.Accounts
  alias FaithfulWord.Accounts.Admin
  alias FaithfulWordApi.Guardian

  # require Ecto.Query
  # require Logger

  plug :scrub_params, "login" when action in [:create]

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"login" => login_params}) do
    with {:ok, email} <- Map.fetch(login_params, "email"),
         {:ok, password} <- Map.fetch(login_params, "password"),
         {:ok, admin} <- Users.auth_admin(email, password) do
      conn
      |> Guardian.Plug.sign_in(admin)
      |> put_flash(:info, gettext("Welcome %{user_name}!", user_name: admin.name))
      # |> redirect(to: offer_path(conn, :index))
    else
      _ ->
        conn
        |> put_flash(:error, "Invalid credentials!")
        |> render("new.html")
    end

    # with {:ok, email} <- Map.fetch(auth_params, "email"),
    #      {:ok, password} <- Map.fetch(auth_params, "password"),
    #      {:ok, admin} <- Accounts.auth_admin(email, password) do
    #   conn
    #   |> Guardian.Plug.sign_in(admin)
    #   |> put_flash(:info, gettext("Welcome %{user_name}!", user_name: admin.name))
    #   |> redirect(to: page_path(conn, :index))
    # else
    #   _ ->
    #     conn
    #     |> put_flash(:error, "Invalid credentials!")
    #     |> render("new.html")
    # end
  end

  # def destroy(conn, _params) do
  #   conn
  #   |> Guardian.Plug.sign_out()
  #   |> put_flash(:info, gettext("Successfully logged out! See you!"))
  #   |> redirect(to: Routes.login_path(conn, :new))
  # end

  # def login_error(conn, {_type, _reason}, _opts) do
  #   conn
  #   |> put_flash(:error, gettext("Authentication required"))
  #   |> redirect(to: Routes.login_path(conn, :new))
  # end

  # def callback(conn, %{"magic_token" => magic_token}) do
  #   # require Logger
  #   # {:ok, access_token, _claims} = FaithfulWordApi.Guardian.exchange_magic(magic_token)
  #   # Logger.debug """
  #   # access_token: #{inspect(access_token)}
  #   # _claims: #{inspect(_claims)}
  #   # """
  #   case Guardian.decode_magic(magic_token) do
  #     {:ok, user, _claims} ->
  #       conn
  #       |> Guardian.Plug.sign_in(user)
  #       |> redirect(to: Routes.page_path(conn, :index))

  #     _ ->
  #       conn
  #       |> put_flash(:error, "Invalid magic link.")
  #       |> redirect(to: Routes.login_path(conn, :new))
  #   end
  # end
end
