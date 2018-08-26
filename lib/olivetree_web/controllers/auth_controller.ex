defmodule OlivetreeWeb.AuthController do
  import Olivetree.Mailer
  
  use OlivetreeWeb, :controller

  alias Olivetree.Users
  alias OlivetreeWeb.Guardian

  plug :scrub_params, "auth" when action in [:do_login]

  def show_login(conn, _params) do
    render(conn, "login.html")
  end

  def do_login(conn, %{"auth" => auth_params}) do
    with {:ok, email} <- Map.fetch(auth_params, "email"),
         {:ok, password} <- Map.fetch(auth_params, "password"),
         {:ok, admin} <- Users.auth_admin(email, password) do
      conn
      |> Guardian.Plug.sign_in(admin)
      |> put_flash(:info, gettext("Welcome %{user_name}!", user_name: admin.name))
      |> redirect(to: page_path(conn, :index))
    else
      _ ->
        conn
        |> put_flash(:error, "Invalid credentials!")
        |> render("login.html")
    end
  end

  def do_logout(conn, _params) do
    conn
    |> Guardian.Plug.sign_out()
    |> put_flash(:info, gettext("Successfully logged out! See you!"))
    |> redirect(to: auth_path(conn, :show_login))
  end

  def show_register(conn, _params) do
    render(conn, "register.html", changeset: {})
  end

  def do_register(conn, %{"auth" => auth_params}) do
    with {:ok, email} <- Map.fetch(auth_params, "email"),
         {:ok, password} <- Map.fetch(auth_params, "password") do
        #  {:ok, admin} <- Users.auth_admin(email, password) do
      conn
      # |> Guardian.Plug.sign_in(admin)
      |> put_flash(:info, gettext("Welcome %{user_name}!", user_name: "username"))
      # |> redirect(to: offer_path(conn, :index))
    else
      _ ->
        conn
        |> put_flash(:error, "Invalid email!")
        |> render("register.html")
    end
  end

  def auth_error(conn, {_type, _reason}, _opts) do
    conn
    |> put_flash(:error, gettext("Authentication required"))
    |> redirect(to: auth_path(conn, :show_login))
  end

end
