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
        |> render(ErrorView, "403.json", %{message: "language not found in supported list."})
      media_music_v12 ->
        Logger.debug("media_music_v12 #{inspect %{attributes: media_music_v12}}")
        render(conn, MediaMusicV12View, "indexv12.json", %{media_music_v12: media_music_v12})

        # Enum.at(conn.path_info, 0)
        # |> case do
          # api_version ->
            # render(conn, "index.json", %{media_gospel: media_gospel})
            # render(conn, BookTitleView, "index.json", %{booktitle: booktitle, api_version: api_version})
            # render(conn, UserView, "user_with_token.json", %{user: user, token: token})
        # end
      end
  end

  def indexv13(conn, params = %{"uuid" => gid_str, "offset" => offset, "limit" => limit}) do
    V13.music_media_by_uuid(gid_str, offset, limit)
    |>
    case do
      nil ->
        put_status(conn, 403)
        |> render(ErrorView, "403.json", %{message: "language not found in supported list."})
      media_music_v13 ->
        Logger.debug("media_music_v13 #{inspect %{attributes: media_music_v13}}")
        Enum.at(conn.path_info, 0)
        |> case do
          api_version ->
            api_version = String.trim_leading(api_version, "v")
            render(conn, MediaMusicV13View, "indexv13.json", %{media_music_v13: media_music_v13, api_version: api_version})
            # render(conn, BookTitleView, "index.json", %{booktitle: booktitle, api_version: api_version})
            # render(conn, UserView, "user_with_token.json", %{user: user, token: token})
        end
      end
  end

  def create(conn, %{"media_music" => media_music_params}) do
    with {:ok, %MediaMusic{} = media_music} <- Content.create_media_music(media_music_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.media_music_path(conn, :show, media_music))
      |> render("show.json", media_music: media_music)
    end
  end

  def show(conn, %{"id" => id}) do
    media_music = Content.get_media_music!(id)
    render(conn, "show.json", media_music: media_music)
  end

  def update(conn, %{"id" => id, "media_music" => media_music_params}) do
    media_music = Content.get_media_music!(id)

    with {:ok, %MediaMusic{} = media_music} <- Content.update_media_music(media_music, media_music_params) do
      render(conn, "show.json", media_music: media_music)
    end
  end

  def delete(conn, %{"id" => id}) do
    media_music = Content.get_media_music!(id)

    with {:ok, %MediaMusic{}} <- Content.delete_media_music(media_music) do
      send_resp(conn, :no_content, "")
    end
  end
end
