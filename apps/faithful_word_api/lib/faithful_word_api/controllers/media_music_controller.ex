defmodule FaithfulWordApi.MediaMusicController do
  use FaithfulWordApi, :controller

  alias FaithfulWord.Content
  alias FaithfulWord.Content.MediaMusic

  action_fallback FaithfulWordApi.FallbackController

  def index(conn, _params) do
    mediamusic = Content.list_mediamusic()
    render(conn, "index.json", mediamusic: mediamusic)
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
