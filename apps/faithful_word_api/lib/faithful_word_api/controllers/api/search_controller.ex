defmodule FaithfulWordApi.SearchController do
  use FaithfulWordApi, :controller

  alias FaithfulWordApi.V13
  alias FaithfulWordApi.ErrorView
  alias FaithfulWordApi.SearchV13View

  require Logger

  action_fallback FaithfulWordApi.FallbackController

  def indexv13(conn, params = %{"q" => query_string, "offset" => offset, "limit" => limit}) do
    V13.search(query_string, offset, limit)
    |>
    case do
      nil ->
        put_status(conn, 403)
        |> render(ErrorView, "403.json", %{message: "something bad happened"})
      search_v13 ->
        Logger.debug("search_v13 #{inspect %{attributes: search_v13}}")
        Enum.at(conn.path_info, 0)
        |> case do
          api_version ->
            api_version = String.trim_leading(api_version, "v")
            render(conn, SearchV13View, "indexv13.json", %{search_v13: search_v13, api_version: api_version})
            # render(conn, BookTitleView, "index.json", %{booktitle: booktitle, api_version: api_version})
            # render(conn, UserView, "user_with_token.json", %{user: user, token: token})
        end
      end
  end

end
