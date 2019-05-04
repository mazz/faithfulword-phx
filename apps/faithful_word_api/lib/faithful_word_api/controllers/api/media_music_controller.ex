defmodule FaithfulWordApi.MediaMusicController do
  use FaithfulWordApi, :controller

  alias FaithfulWord.Content
  alias DB.Schema.MediaMusic
  alias FaithfulWordApi.V12
  alias FaithfulWordApi.V13

  alias FaithfulWordApi.ErrorView
  alias FaithfulWordApi.MediaMusicV12View
  alias FaithfulWordApi.MediaMusicV13View

  require Logger

  action_fallback FaithfulWordApi.FallbackController

  def indexv12(conn, params = %{"mid" => mid_str}) do
    V12.music_media_by_mid(mid_str)
    |>
    case do
      nil ->
        put_status(conn, 403)
        |> put_view(ErrorView)
        |> render("403.json", %{message: "language not found in supported list."})
      media_music_v12 ->
        Logger.debug("media_music_v12 #{inspect %{attributes: media_music_v12}}")
        conn
        |> put_view(MediaMusicV12View)
        |> render("indexv12.json", %{media_music_v12: media_music_v12})
      end
  end

  def indexv13(conn, params = %{"uuid" => gid_str, "offset" => offset, "limit" => limit}) do
    V13.music_media_by_uuid(gid_str, offset, limit)
    |>
    case do
      nil ->
        put_status(conn, 403)
        |> put_view(ErrorView)
        |> render("403.json", %{message: "language not found in supported list."})
      media_music_v13 ->
        Logger.debug("media_music_v13 #{inspect %{attributes: media_music_v13}}")
        Enum.at(conn.path_info, 0)
        |> case do
          api_version ->
            api_version = String.trim_leading(api_version, "v")
            conn
            |> put_view(MediaMusicV13View)
            |> render("indexv13.json", %{media_music_v13: media_music_v13, api_version: api_version})
        end
      end
  end
end
