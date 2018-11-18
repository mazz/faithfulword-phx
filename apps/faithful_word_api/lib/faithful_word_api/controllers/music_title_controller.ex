defmodule FaithfulWordApi.MusicTitleController do
  use FaithfulWordApi, :controller

  alias FaithfulWord.Content
  alias FaithfulWord.Content.MusicTitle

  action_fallback FaithfulWordApi.FallbackController

  def index(conn, _params) do
    musictitle = Content.list_musictitle()
    render(conn, "index.json", musictitle: musictitle)
  end

  def create(conn, %{"music_title" => music_title_params}) do
    with {:ok, %MusicTitle{} = music_title} <- Content.create_music_title(music_title_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.music_title_path(conn, :show, music_title))
      |> render("show.json", music_title: music_title)
    end
  end

  def show(conn, %{"id" => id}) do
    music_title = Content.get_music_title!(id)
    render(conn, "show.json", music_title: music_title)
  end

  def update(conn, %{"id" => id, "music_title" => music_title_params}) do
    music_title = Content.get_music_title!(id)

    with {:ok, %MusicTitle{} = music_title} <- Content.update_music_title(music_title, music_title_params) do
      render(conn, "show.json", music_title: music_title)
    end
  end

  def delete(conn, %{"id" => id}) do
    music_title = Content.get_music_title!(id)

    with {:ok, %MusicTitle{}} <- Content.delete_music_title(music_title) do
      send_resp(conn, :no_content, "")
    end
  end
end
