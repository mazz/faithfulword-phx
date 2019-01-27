defmodule FaithfulWordApi.BookController do
  use FaithfulWordApi, :controller

  alias FaithfulWordApi.ErrorView
  alias FaithfulWordApi.BookView
  alias FaithfulWordApi.BookV12View
  alias FaithfulWordApi.V12
  alias FaithfulWordApi.V13

  require Logger
  require Ecto.Query

  action_fallback FaithfulWordApi.FallbackController

  def indexv12(conn, %{"language-id" => lang}) do
    Logger.debug("lang #{inspect %{attributes: lang}}")
    IO.inspect(conn)
    #  path_info: ["v1.2", "books"],
    # books =
    # cond do
      # Enum.member?(conn.path_info, "v1.2") ->
      # Enum.member?(conn.path_info, "v1.3") ->
        # V13.books_by_language(lang)
      # true ->
        # nil
    # end
    V12.books_by_language(lang)
    |> case do
      nil ->
        put_status(conn, 403)
        |> render(ErrorView, "403.json", %{message: "language not found in supported list."})
      book_v12 ->
        render(conn, BookV12View, "indexv12.json", %{book_v12: book_v12})
        # render(conn, "indexv12.json", %{books: books})
        # Logger.debug("books #{inspect %{attributes: books}}")
        # Enum.at(conn.path_info, 0)
        # |> case do
          # api_version ->

        # end
    end
  end

  def index(conn, %{"language-id" => lang}) do
    # Logger.debug("lang #{inspect %{attributes: lang}}")
    # IO.inspect(conn)
    #  path_info: ["v1.2", "books"],
    # books =
    # cond do
      # Enum.member?(conn.path_info, "v1.2") ->
      #   V12.books_by_language(lang)
      # Enum.member?(conn.path_info, "v1.3") ->

    #   true ->
    #     nil
    # end
    V13.books_by_language(lang)
    |> case do
      nil ->
        put_status(conn, 403)
        |> render(ErrorView, "403.json", %{message: "language not found in supported list."})
      book ->
        # Logger.debug("books #{inspect %{attributes: books}}")
        Enum.at(conn.path_info, 0)
        |> case do
          api_version ->
            render(conn, BookView, "index.json", %{book: book, api_version: api_version})
        end
    end
  end
end
