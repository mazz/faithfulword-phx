defmodule FaithfulWordApi.BookController do
  use FaithfulWordApi, :controller

  alias FaithfulWordApi.ErrorView
  alias FaithfulWord.API.V13


  require Logger
  require Ecto.Query

  action_fallback FaithfulWordApi.FallbackController

  def index(conn, %{"language-id" => lang}) do
    Logger.debug("lang #{inspect %{attributes: lang}}")

    books = V13.books_by_language(lang)
    Logger.debug("books #{inspect %{attributes: books}}")

    if books != nil do
      render(conn, "index.json", book: books)
    else
      put_status(conn, 403)
      |> render(ErrorView, "403.json", %{message: "language not found in supported list."})
    end
  end
end
