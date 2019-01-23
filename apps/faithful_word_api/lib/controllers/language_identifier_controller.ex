defmodule FaithfulWordApi.LanguageIdentifierController do
  use FaithfulWordApi, :controller

  alias FaithfulWord.Content
  alias FaithfulWord.DB.Schema.LanguageIdentifier

  action_fallback FaithfulWordApi.FallbackController

  def index(conn, _params) do
    languageidentifier = Content.list_languageidentifier()
    render(conn, "index.json", languageidentifier: languageidentifier)
  end

  def create(conn, %{"language_identifier" => language_identifier_params}) do
    with {:ok, %LanguageIdentifier{} = language_identifier} <- Content.create_language_identifier(language_identifier_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.language_identifier_path(conn, :show, language_identifier))
      |> render("show.json", language_identifier: language_identifier)
    end
  end

  def show(conn, %{"id" => id}) do
    language_identifier = Content.get_language_identifier!(id)
    render(conn, "show.json", language_identifier: language_identifier)
  end

  def update(conn, %{"id" => id, "language_identifier" => language_identifier_params}) do
    language_identifier = Content.get_language_identifier!(id)

    with {:ok, %LanguageIdentifier{} = language_identifier} <- Content.update_language_identifier(language_identifier, language_identifier_params) do
      render(conn, "show.json", language_identifier: language_identifier)
    end
  end

  def delete(conn, %{"id" => id}) do
    language_identifier = Content.get_language_identifier!(id)

    with {:ok, %LanguageIdentifier{}} <- Content.delete_language_identifier(language_identifier) do
      send_resp(conn, :no_content, "")
    end
  end
end
