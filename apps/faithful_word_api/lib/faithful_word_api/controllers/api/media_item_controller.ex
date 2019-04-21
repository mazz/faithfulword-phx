defmodule FaithfulWordApi.MediaItemController do
  use FaithfulWordApi, :controller

  alias DB.Schema.MediaItem
  alias FaithfulWordApi.V13

  alias FaithfulWordApi.ErrorView
  alias FaithfulWordApi.MediaItemV13View

  require Logger

  action_fallback FaithfulWordApi.FallbackController

  def indexv13(conn, params = %{"uuid" => playlist_uuid, "language-id" => language_id, "offset" => offset, "limit" => limit}) do
    V13.media_items_by_playlist_uuid(playlist_uuid, language_id, offset, limit)
    |>
    case do
      nil ->
        put_status(conn, 403)
        |> render(ErrorView, "403.json", %{message: "error retrieving media items."})
      media_item_v13 ->
        Logger.debug("media_item_v13 #{inspect %{attributes: media_item_v13}}")
        Enum.at(conn.path_info, 0)
        |> case do
          api_version ->
            api_version = String.trim_leading(api_version, "v")
            render(conn, MediaItemV13View, "indexv13.json", %{media_item_v13: media_item_v13, api_version: api_version})
            # render(conn, BookTitleView, "index.json", %{booktitle: booktitle, api_version: api_version})
            # render(conn, UserView, "user_with_token.json", %{user: user, token: token})
        end
      end
  end
end
