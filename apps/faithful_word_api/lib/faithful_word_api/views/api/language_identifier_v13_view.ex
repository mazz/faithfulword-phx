defmodule FaithfulWordApi.LanguageIdentifierV13View do
  use FaithfulWordApi, :view
  alias FaithfulWordApi.LanguageIdentifierV13View

  def render("indexv13.json", %{
        language_identifier_v13: language_identifier_v13,
        api_version: api_version
      }) do
    %{
      result:
        render_many(
          language_identifier_v13,
          LanguageIdentifierV13View,
          "language_identifier_v13.json"
        ),
      page_number: language_identifier_v13.page_number,
      page_size: language_identifier_v13.page_size,
      status: "success",
      total_entries: language_identifier_v13.total_entries,
      total_pages: language_identifier_v13.total_pages,
      version: api_version
    }

    # %{data: render_many(language_identifier_v13, LanguageIdentifierV13View, "language_identifier_v13.json")}
  end

  def render("show.json", %{language_identifier_v13: language_identifier_v13}) do
    %{
      data:
        render_one(
          language_identifier_v13,
          LanguageIdentifierV13View,
          "language_identifier_v13.json"
        )
    }
  end

  def render("language_identifier_v13.json", %{language_identifier_v13: language_identifier_v13}) do
    %{
      language_identifier: language_identifier_v13.identifier,
      source_material: language_identifier_v13.source_material,
      supported: language_identifier_v13.supported,
      uuid: language_identifier_v13.uuid
    }
  end
end
