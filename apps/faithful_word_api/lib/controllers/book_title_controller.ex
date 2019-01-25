defmodule FaithfulWordApi.BookTitleController do
  use FaithfulWordApi, :controller

  alias FaithfulWord.Content
  alias DB.Schema.BookTitle

  action_fallback FaithfulWordApi.FallbackController

  def index(conn, _params) do
    booktitle = Content.list_booktitle()
    render(conn, "index.json", booktitle: booktitle)
  end

  def create(conn, %{"book_title" => book_title_params}) do
    with {:ok, %BookTitle{} = book_title} <- Content.create_book_title(book_title_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.book_title_path(conn, :show, book_title))
      |> render("show.json", book_title: book_title)
    end
  end

  def show(conn, %{"id" => id}) do
    book_title = Content.get_book_title!(id)
    render(conn, "show.json", book_title: book_title)
  end

  def update(conn, %{"id" => id, "book_title" => book_title_params}) do
    book_title = Content.get_book_title!(id)

    with {:ok, %BookTitle{} = book_title} <- Content.update_book_title(book_title, book_title_params) do
      render(conn, "show.json", book_title: book_title)
    end
  end

  def delete(conn, %{"id" => id}) do
    book_title = Content.get_book_title!(id)

    with {:ok, %BookTitle{}} <- Content.delete_book_title(book_title) do
      send_resp(conn, :no_content, "")
    end
  end
end
