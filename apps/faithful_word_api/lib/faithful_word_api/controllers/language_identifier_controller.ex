defmodule FaithfulWordApi.LanguageIdentifierController do
  use FaithfulWordApi, :controller

  alias FaithfulWord.Content
  alias DB.Schema.LanguageIdentifier
  alias FaithfulWordApi.V12
  alias FaithfulWordApi.V13

  alias FaithfulWordApi.ErrorView
  alias FaithfulWordApi.LanguageIdentifierV12View
  alias FaithfulWordApi.LanguageIdentifierView

  require Logger

  action_fallback FaithfulWordApi.FallbackController

  def indexv12(conn, _params) do
    V12.language_identifiers()
    |> case do
      nil ->
        put_status(conn, 403)
        |> render(ErrorView, "403.json", %{message: "language not found in supported list."})
      language_identifier_v12 ->
        Logger.debug("language_identifier_v12 #{inspect %{attributes: language_identifier_v12}}")
        render(conn, LanguageIdentifierV12View, "indexv12.json", %{language_identifier_v12: language_identifier_v12})
    end
  end

  # def index(conn, %{"language-id" => lang}) do
  def index(conn,  %{"offset" => offset, "limit" => limit}) do
    V13.language_identifiers(offset, limit)
    |>
    case do
      nil ->
        put_status(conn, 403)
        |> render(ErrorView, "403.json", %{message: "language not found in supported list."})
      language_identifier ->
        # render(conn, GospelView, "index.json", %{language_identifier: language_identifier})

        Logger.debug("language_identifier #{inspect %{attributes: language_identifier}}")
        Enum.at(conn.path_info, 0)
        |>
        case do
          api_version ->
            api_version = String.trim_leading(api_version, "v")
            render(conn, LanguageIdentifierView, "index.json", %{language_identifier: language_identifier, api_version: api_version})
        end
    end
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
