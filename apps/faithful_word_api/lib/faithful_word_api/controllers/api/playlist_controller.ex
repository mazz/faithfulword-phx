defmodule FaithfulWordApi.PlaylistController do
  use FaithfulWordApi, :controller

  alias FaithfulWordApi.V13
  alias FaithfulWordApi.ErrorView
  alias FaithfulWordApi.PlaylistV13View
  alias FaithfulWordApi.PlaylistDetailsV13View

  require Logger

  action_fallback FaithfulWordApi.FallbackController

  plug(
    Guardian.Plug.EnsureAuthenticated,
    [handler: FaithfulWordApi.AuthController]
    when action in [
           # :addv13
         ]
  )

  @spec detailsv13(Plug.Conn.t(), map) :: Plug.Conn.t()
  def detailsv13(
        conn,
        params = %{
          "uuid" => uuid_str,
          "offset" => offset,
          "limit" => limit
        }
      ) do
    # optional params
    updated_after = Map.get(params, "upd-after", nil)

    Logger.debug("updated_after #{inspect(%{attributes: updated_after})}")

    V13.playlist_details_by_uuid(uuid_str, offset, limit, updated_after)
    |> case do
      nil ->
        put_status(conn, 403)
        |> put_view(ErrorView)
        |> render("403.json", %{message: "language not found in supported list."})

      playlist_details_v13 ->
        Logger.debug("playlist_details_v13 #{inspect(%{attributes: playlist_details_v13})}")

        Enum.at(conn.path_info, 1)
        |> case do
          api_version ->
            api_version = String.trim_leading(api_version, "v")

            conn
            |> put_view(PlaylistDetailsV13View)
            |> render("detailsv13.json", %{
              playlist_details_v13: playlist_details_v13,
              api_version: api_version
            })
        end
    end
  end

  def add_or_update_v13(
        conn,
        params = %{
          "ordinal" => ordinal,
          "basename" => basename,
          "media_category" => media_category,
          "channel_id" => channel_id
        }
      ) do
    # optional params
    playlist_uuid = Map.get(params, "playlist_uuid", nil)
    small_thumbnail_path = Map.get(params, "small_thumbnail_path", nil)
    med_thumbnail_path = Map.get(params, "med_thumbnail_path", nil)
    large_thumbnail_path = Map.get(params, "large_thumbnail_path", nil)
    banner_path = Map.get(params, "banner_path", nil)
    localized_titles = Map.get(params, "localized_titles", nil)

    V13.add_or_update_playlist(
      ordinal,
      basename,
      small_thumbnail_path,
      med_thumbnail_path,
      large_thumbnail_path,
      banner_path,
      media_category,
      localized_titles,
      channel_id,
      playlist_uuid
    )
    # |> IO.inspect()
    |> case do
      {:ok, playlist} ->
        Logger.debug("playlist #{inspect(%{attributes: playlist})}")

        conn
        |> put_view(PlaylistV13View)
        |> render("addv13.json", %{
          playlist_v13: playlist,
          api_version: "1.3"
        })

      {:error, _changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(ErrorView)
        |> render("403.json", %{message: "something happened."})
    end
  end

  def delete_v13(
        conn,
        %{
          "playlist_uuid" => playlist_uuid
        }
      ) do
    V13.delete_playlist(playlist_uuid)
    # |> IO.inspect()
    |> case do
      {:ok, playlist} ->
        Logger.debug("playlist #{inspect(%{attributes: playlist})}")

        conn
        |> put_view(PlaylistV13View)
        |> render("deletev13.json", %{
          playlist_v13: playlist,
          api_version: "1.3"
        })

      {:error, error} ->
        conn
        |> put_status(error)
        |> put_view(ErrorView)
        |> render("403.json", %{message: "something happened."})
    end
  end

  def indexv13(
        conn,
        params = %{
          "uuid" => uuid_str,
          "language-id" => language_id,
          "offset" => offset,
          "limit" => limit
        }
      ) do
    # optional params
    updated_after = Map.get(params, "upd-after", nil)

    Logger.debug("updated_after #{inspect(%{attributes: updated_after})}")

    V13.playlists_by_channel_uuid(uuid_str, language_id, offset, limit, updated_after)
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
