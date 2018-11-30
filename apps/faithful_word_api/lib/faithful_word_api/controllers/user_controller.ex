defmodule FaithfulWordApi.UserController do
  use FaithfulWordApi, :controller

  alias FaithfulWord.Accounts
  alias FaithfulWord.Accounts.User
  alias FaithfulWordApi.Auth.Guardian

  action_fallback(FaithfulWordApi.FallbackController)

  def create(conn, params) do
    with {:ok, %User{} = user} <- Accounts.create_user(params) do
      new_conn = Guardian.Plug.sign_in(conn, user)
      jwt = Guardian.Plug.current_token(new_conn)

      new_conn
      |> put_status(:created)
      |> render(FaithfulWordApi.SessionView, "show.json", user: user, jwt: jwt)
    end
  end
end
