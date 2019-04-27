defmodule FaithfulWordApi.SearchController do
  use FaithfulWordApi, :controller

  alias FaithfulWordApi.V13
  alias FaithfulWordApi.ErrorView
  alias FaithfulWordApi.SearchV13View

  require Logger

  action_fallback FaithfulWordApi.FallbackController


  def searchv13(conn,
  %{"query" => query_string,
    "mediaCategory" => mediaCategory,
    "offset" => offset,
    "limit" => limit
  }) do
    V13.search(query_string, mediaCategory, offset, limit)
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
            render(conn, SearchV13View, "searchv13.json", %{search_v13: search_v13, api_version: api_version})
        end
      end
  end

end
