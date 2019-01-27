defmodule FaithfulWordApi.BookView do
  use FaithfulWordApi, :view
  alias FaithfulWordApi.BookView

  require Logger

  def render("index.json", %{books: books, api_version: api_version}) do
    %{result: render_many(books, BookView, "book.json"),
      status: "success",
      version: api_version}
  end

  def render("show.json", %{book: book}) do
    %{data: render_one(book, BookView, "book.json")}
  end

  def render("book.json", %{book: book}) do
    # {"Revelation", "Apocalipse", "2c22a08a-80ee-4ec1-be94-f018892fe8ba", "pt"}
    # {b.basename, title.localizedname, b.uuid, title.language_id}
    Logger.debug("book #{inspect %{attributes: book}}")

    %{title: book.title,
    localizedTitle: book.localizedTitle,
    bid: book.uuid,
    languageId: book.languageId}
  end
end
