defmodule FaithfulWordWeb.PageController do
  use FaithfulWordWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
