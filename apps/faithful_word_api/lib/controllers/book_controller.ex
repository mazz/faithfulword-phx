defmodule FaithfulWordApi.BookController do
  use FaithfulWordApi, :controller

  alias FaithfulWordApi.ErrorView
  alias FaithfulWordApi.V12
  alias FaithfulWordApi.V13

  require Logger
  require Ecto.Query

  action_fallback FaithfulWordApi.FallbackController

  def index(conn, %{"language-id" => lang}) do
    Logger.debug("lang #{inspect %{attributes: lang}}")
    IO.inspect(conn)
    #  path_info: ["v1.2", "books"],
    # books =
    cond do
      Enum.member?(conn.path_info, "v1.2") ->
        V12.books_by_language(lang)
      Enum.member?(conn.path_info, "v1.3") ->
        V13.books_by_language(lang)
      true ->
        nil
    end
    |> case do
      nil ->
        put_status(conn, 403)
        |> render(ErrorView, "403.json", %{message: "language not found in supported list."})
      books ->
        Logger.debug("books #{inspect %{attributes: books}}")
        Enum.at(conn.path_info, 0)
        |> case do
          api_version ->
            render(conn, "index.json", %{books: books, api_version: api_version})
        end
    end
  end
end
