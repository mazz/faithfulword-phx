defmodule FaithfulWordApi.MediaChapterController do
  use FaithfulWordApi, :controller

  alias FaithfulWord.Content
  alias FaithfulWord.Content.MediaChapter

  action_fallback FaithfulWordApi.FallbackController

  def index(conn, _params) do
    mediachapter = Content.list_mediachapter()
    render(conn, "index.json", mediachapter: mediachapter)
  end

  def create(conn, %{"media_chapter" => media_chapter_params}) do
    with {:ok, %MediaChapter{} = media_chapter} <- Content.create_media_chapter(media_chapter_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.media_chapter_path(conn, :show, media_chapter))
      |> render("show.json", media_chapter: media_chapter)
    end
  end

  def show(conn, %{"id" => id}) do
    media_chapter = Content.get_media_chapter!(id)
    render(conn, "show.json", media_chapter: media_chapter)
  end

  def update(conn, %{"id" => id, "media_chapter" => media_chapter_params}) do
    media_chapter = Content.get_media_chapter!(id)

    with {:ok, %MediaChapter{} = media_chapter} <- Content.update_media_chapter(media_chapter, media_chapter_params) do
      render(conn, "show.json", media_chapter: media_chapter)
    end
  end

  def delete(conn, %{"id" => id}) do
    media_chapter = Content.get_media_chapter!(id)

    with {:ok, %MediaChapter{}} <- Content.delete_media_chapter(media_chapter) do
      send_resp(conn, :no_content, "")
    end
  end
end
