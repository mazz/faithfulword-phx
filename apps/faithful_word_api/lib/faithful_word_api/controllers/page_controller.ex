defmodule FaithfulWordApi.PageController do
  use FaithfulWordApi, :controller
  alias FaithfulWordApi.Guardian
  require Logger

  def index(conn, _params) do
    Logger.info("FW_HOSTNAME: #{System.get_env("FW_HOSTNAME")}")

    conn
    # |> assign(:users, Accounts.list_users())
    # |> assign(:current_user, Guardian.Plug.current_resource(conn))
    |> render("index.html")

    # render conn, "index.html"

    # |> send_resp(200, """
    #   index
    #   """)
  end

  def about(conn, _params) do
    render(conn, "about.html")
  end
end
