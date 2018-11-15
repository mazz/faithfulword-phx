defmodule FaithfulWordApi.PageController do
  use FaithfulWordApi, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
