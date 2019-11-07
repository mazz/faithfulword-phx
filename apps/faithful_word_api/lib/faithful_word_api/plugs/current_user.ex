defmodule FaithfulWordApi.Plugs.CurrentUser do
  @moduledoc """
  Plug to store current user (if defined) on the connection.
  """

  import Plug.Conn

  alias Db.Repo
  alias Db.Schema.User
  alias FaithfulWordApi.Guardian.Plug, as: GuardianPlug

  def init(_), do: []

  def call(conn, _) do
    case GuardianPlug.current_resource(conn) do
      %User{} = user -> assign(conn, :current_user, user)
      _ -> conn
    end
  end

  def current_user(conn) do
    Map.get(conn.assigns, :current_user)
  end

  def user_logged_in?(conn), do: !is_nil(Map.get(conn.assigns, :current_user))
end
