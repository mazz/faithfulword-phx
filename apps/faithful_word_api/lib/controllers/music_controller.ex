defmodule FaithfulWordApi.MusicController do
  use FaithfulWordApi, :controller

  alias FaithfulWord.Content
  alias FaithfulWord.Content.Music

  action_fallback FaithfulWordApi.FallbackController

  def index(conn, _params) do
    music = Content.list_music()
    render(conn, "index.json", music: music)
  end

  def create(conn, %{"music" => music_params}) do
    with {:ok, %Music{} = music} <- Content.create_music(music_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.music_path(conn, :show, music))
      |> render("show.json", music: music)
    end
  end

  def show(conn, %{"id" => id}) do
    music = Content.get_music!(id)
    render(conn, "show.json", music: music)
  end

  def update(conn, %{"id" => id, "music" => music_params}) do
    music = Content.get_music!(id)

    with {:ok, %Music{} = music} <- Content.update_music(music, music_params) do
      render(conn, "show.json", music: music)
    end
  end

  def delete(conn, %{"id" => id}) do
    music = Content.get_music!(id)

    with {:ok, %Music{}} <- Content.delete_music(music) do
      send_resp(conn, :no_content, "")
    end
  end
end
