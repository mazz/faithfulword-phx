defmodule OlivetreeWeb.AuthController do
  import Olivetree.Mailer
  
  use OlivetreeWeb, :controller

  alias Olivetree.Users
  alias OlivetreeWeb.Guardian

  plug :scrub_params, "auth" when action in [:create]

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"auth" => auth_params}) do
    with {:ok, email} <- Map.fetch(auth_params, "email") do
      case Users.get_or_create_by_email(email) do 
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
    #      {:ok, admin} <- Users.auth_admin(email, password) do
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
    |> redirect(to: auth_path(conn, :new))
  end

  def auth_error(conn, {_type, _reason}, _opts) do
    conn
    |> put_flash(:error, gettext("Authentication required"))
    |> redirect(to: auth_path(conn, :new))
  end

  def callback(conn, %{"magic_token" => magic_token}) do
    case Guardian.decode_magic(magic_token) do
      {:ok, user, _claims} ->
        conn
        |> Guardian.Plug.sign_in(user)
        |> redirect(to: page_path(conn, :index))

      _ ->
        conn
        |> put_flash(:error, "Invalid magic link.")
        |> redirect(to: auth_path(conn, :new))
    end
  end
end
