defmodule FaithfulWordApi.LanguageIdentifierView do
  use FaithfulWordApi, :view
  alias FaithfulWordApi.LanguageIdentifierView

  def render("index.json",%{language_identifier: language_identifier, api_version: api_version}) do
    %{result: render_many(language_identifier, LanguageIdentifierView, "language_identifier.json"),
    pageNumber: language_identifier.page_number,
    pageSize: language_identifier.page_size,
    status: "success",
    totalEntries: language_identifier.total_entries,
    totalPages: language_identifier.total_pages,
    version: api_version}
    # %{data: render_many(language_identifier, LanguageIdentifierView, "language_identifier.json")}
  end

  def render("show.json", %{language_identifier: language_identifier}) do
    %{data: render_one(language_identifier, LanguageIdentifierView, "language_identifier.json")}
  end

  def render("language_identifier.json", %{language_identifier: language_identifier}) do
    %{languageIdentifier: language_identifier.identifier,
    sourceMaterial: language_identifier.source_material,
    supported: language_identifier.supported,
    uuid: language_identifier.uuid}
  end
end
