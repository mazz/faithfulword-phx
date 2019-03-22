defmodule FaithfulWordApi.ChapterController do
  use FaithfulWordApi, :controller

  alias FaithfulWord.Content
  alias DB.Schema.Chapter

  action_fallback FaithfulWordApi.FallbackController

  def index(conn, _params) do
    chapter = Content.list_chapter()
    render(conn, "index.json", chapter: chapter)
  end

  def create(conn, %{"chapter" => chapter_params}) do
    with {:ok, %Chapter{} = chapter} <- Content.create_chapter(chapter_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.chapter_path(conn, :show, chapter))
      |> render("show.json", chapter: chapter)
    end
  end

  def show(conn, %{"id" => id}) do
    chapter = Content.get_chapter!(id)
    render(conn, "show.json", chapter: chapter)
  end

  def update(conn, %{"id" => id, "chapter" => chapter_params}) do
    chapter = Content.get_chapter!(id)

    with {:ok, %Chapter{} = chapter} <- Content.update_chapter(chapter, chapter_params) do
      render(conn, "show.json", chapter: chapter)
    end
  end

  def delete(conn, %{"id" => id}) do
    chapter = Content.get_chapter!(id)

    with {:ok, %Chapter{}} <- Content.delete_chapter(chapter) do
      send_resp(conn, :no_content, "")
    end
  end
end
