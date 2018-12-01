defmodule FaithfulWordApi.Auth.Web.CurrentUser do
  @moduledoc """
  Plug to store current user (if defined) on the connection.
  """

  import Plug.Conn

  alias FaithfulWord.Accounts.User
  # alias FaithfulWordApi.Guardian.Plug, as: GuardianPlug
  # alias FaithfulWordApi.Auth.Guardian, as: GuardianPlug
  alias FaithfulWordApi.Auth.Guardian

  def init(_), do: []

  def call(conn, _) do
    case Guardian.Plug.current_resource(conn) do
      %User{} = user -> assign(conn, :current_user, user)
      _ -> conn
    end
  end

  def current_user(conn) do
    Map.get(conn.assigns, :current_user)
  end

  def user_logged_in?(conn), do: !is_nil(Map.get(conn.assigns, :current_user))
end
