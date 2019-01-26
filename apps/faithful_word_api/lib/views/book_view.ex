defmodule FaithfulWordApi.BookView do
  use FaithfulWordApi, :view
  alias FaithfulWordApi.BookView

  require Logger

  # media

  # def render("index.json", %{media: media, api_version: api_version}) do
  #   %{result: render_many(media, BookView, "media.json"),
  #     status: "success",
  #     version: api_version}
  # end

  # def render("show.json", %{media: media}) do
  #   %{data: render_one(media, BookView, "media.json")}
  # end

  # def render("media.json", %{media: media}) do
  #   # {"Revelation", "Apocalipse", "2c22a08a-80ee-4ec1-be94-f018892fe8ba", "pt"}
  #   # {b.basename, title.localizedname, b.uuid, title.language_id}
  #   Logger.debug("media #{inspect %{attributes: media}}")

  #   %{basename: media.basename}
  #   # %{title: book.title,
  #   # localizedTitle: book.localizedTitle,
  #   # uuid: book.uuid,
  #   # languageId: book.languageId}
  # end

  # books

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
    uuid: book.uuid,
    languageId: book.languageId}
  end
end
