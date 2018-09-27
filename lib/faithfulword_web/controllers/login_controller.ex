defmodule FaithfulwordWeb.LoginController do
  import Faithfulword.Mailer
  
  use FaithfulwordWeb, :controller

  alias Faithfulword.Accounts
  alias FaithfulwordWeb.Guardian

  plug :scrub_params, "login" when action in [:create]

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"login" => login_params}) do
    with {:ok, email} <- Map.fetch(login_params, "email") do
      case Accounts.get_or_create_by_email(email) do 
        {:ok, user} ->
          {:ok, _, _} = Guardian.send_magic_link(user)
          render(conn, "create.html")

        {:error, changeset} ->
          conn
          |> assign(:changeset, changeset)
          |> render("new.html")
      end
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

  def destroy(conn, _params) do
    conn
    |> Guardian.Plug.sign_out()
    |> put_flash(:info, gettext("Successfully logged out! See you!"))
    |> redirect(to: login_path(conn, :new))
  end

  def login_error(conn, {_type, _reason}, _opts) do
    conn
    |> put_flash(:error, gettext("Authentication required"))
    |> redirect(to: login_path(conn, :new))
  end

  def callback(conn, %{"magic_token" => magic_token}) do
    # require Logger
    # {:ok, access_token, _claims} = FaithfulwordWeb.Guardian.exchange_magic(magic_token)
    # Logger.debug """
    # access_token: #{inspect(access_token)}
    # _claims: #{inspect(_claims)}
    # """
    case Guardian.decode_magic(magic_token) do
      {:ok, user, _claims} ->
        conn
        |> Guardian.Plug.sign_in(user)
        |> redirect(to: page_path(conn, :index))

      _ ->
        conn
        |> put_flash(:error, "Invalid magic link.")
        |> redirect(to: login_path(conn, :new))
    end
  end
end
