defmodule FaithfulWordApi.BookController do
  use FaithfulWordApi, :controller

  alias FaithfulWordApi.ErrorView
  alias FaithfulWordApi.V12
  alias FaithfulWordApi.V13
  alias DB.Schema.BookTitle

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

    # result =
    #   if user != nil do
    #     Authenticator.associate_user_with_third_party(user, provider, code)
    #   else
    #     Authenticator.get_user_by_third_party!(provider, code, params["invitation_token"])
    #   end

    # case result do
    #   {:error, message} ->
    #     conn
    #     |> put_status(:unauthorized)
    #     |> render(ErrorView, "error.json", message: message)

    #   user ->
    #     signin_user(conn, user)
    # end
  # end

# end

