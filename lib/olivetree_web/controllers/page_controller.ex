defmodule OlivetreeWeb.PageController do
  use OlivetreeWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
