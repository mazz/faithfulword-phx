defmodule FaithfulWordApi.PlaylistController do
  use FaithfulWordApi, :controller

  alias FaithfulWordApi.V13
  alias FaithfulWordApi.ErrorView
  alias FaithfulWordApi.PlaylistV13View

  require Logger

  action_fallback FaithfulWordApi.FallbackController

  def detailsv13(
        conn,
        _params = %{
          "uuid" => uuid_str
        }
      ) do
    V13.playlist_details_by_uuid(uuid_str)
    |> case do
      nil ->
        put_status(conn, 403)
        |> put_view(ErrorView)
        |> render("403.json", %{message: "language not found in supported list."})

      playlist_v13 ->
        Logger.debug("playlist_v13 #{inspect(%{attributes: playlist_v13})}")

        Enum.at(conn.path_info, 1)
        |> case do
          api_version ->
            api_version = String.trim_leading(api_version, "v")

            conn
            |> put_view(PlaylistV13View)
            |> render("indexv13.json", %{playlist_v13: playlist_v13, api_version: api_version})
        end
    end
  end

  def addv13(conn, %{
        "ordinal" => ordinal,
        "basename" => basename,
        "small_thumbnail_path" => small_thumbnail_path,
        "med_thumbnail_path" => med_thumbnail_path,
        "large_thumbnail_path" => large_thumbnail_path,
        "banner_path" => banner_path,
        "media_category" => media_category,
        "localized_titles" => localized_titles,
        "channel_id" => channel_id
      }) do
    V13.add_playlist(
      ordinal,
      basename,
      small_thumbnail_path,
      med_thumbnail_path,
      large_thumbnail_path,
      banner_path,
      media_category,
      localized_titles,
      channel_id
    )
    |> case do
      nil ->
        put_status(conn, 403)
        |> put_view(ErrorView)
        |> render("403.json", %{message: "something happened."})

      playlist_v13 ->
        # Logger.debug("channels #{inspect %{attributes: channels}}")
        Logger.debug("playlist_v13 #{inspect(%{attributes: playlist_v13})}")

        Enum.at(conn.path_info, 1)
        |> case do
          api_version ->
            Logger.debug("api_version #{inspect(%{attributes: api_version})}")
            api_version = String.trim_leading(api_version, "v")

            conn
            |> put_view(PlaylistV13View)
            |> render("addv13.json", %{
              playlist_v13: playlist_v13,
              api_version: api_version
            })
        end
    end
  end

  def indexv13(
        conn,
        _params = %{
          "uuid" => uuid_str,
          "language-id" => language_id,
          "offset" => offset,
          "limit" => limit
        }
      ) do
    V13.playlists_by_channel_uuid(uuid_str, language_id, offset, limit)
    |> case do
      nil ->
        put_status(conn, 403)
        |> put_view(ErrorView)
        |> render("403.json", %{message: "language not found in supported list."})

      playlist_v13 ->
        Logger.debug("playlist_v13 #{inspect(%{attributes: playlist_v13})}")

        Enum.at(conn.path_info, 1)
        |> case do
          api_version ->
            api_version = String.trim_leading(api_version, "v")

            conn
            |> put_view(PlaylistV13View)
            |> render("indexv13.json", %{playlist_v13: playlist_v13, api_version: api_version})
        end
    end
  end
end
