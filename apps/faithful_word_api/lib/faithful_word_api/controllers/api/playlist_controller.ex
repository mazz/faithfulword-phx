defmodule FaithfulWordApi.PlaylistController do
  use FaithfulWordApi, :controller

  alias FaithfulWordApi.V13
  alias FaithfulWordApi.ErrorView
  alias FaithfulWordApi.PlaylistV13View

  require Logger

  action_fallback FaithfulWordApi.FallbackController

  def indexv13(conn, params = %{"uuid" => uuid_str, "language-id" => language_id, "offset" => offset, "limit" => limit}) do
    V13.playlists_by_channel_uuid(uuid_str, language_id, offset, limit)
    |>
    case do
      nil ->
        put_status(conn, 403)
        |> render(ErrorView, "403.json", %{message: "language not found in supported list."})
      playlist_v13 ->
        Logger.debug("playlist_v13 #{inspect %{attributes: playlist_v13}}")
        Enum.at(conn.path_info, 0)
        |> case do
          api_version ->
            api_version = String.trim_leading(api_version, "v")
            render(conn, PlaylistV13View, "indexv13.json", %{playlist_v13: playlist_v13, api_version: api_version})
            # render(conn, BookTitleView, "index.json", %{booktitle: booktitle, api_version: api_version})
            # render(conn, UserView, "user_with_token.json", %{user: user, token: token})
        end
      end
  end

end
