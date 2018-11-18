defmodule FaithfulWordApi.LanguageIdentifierView do
  use FaithfulWordApi, :view
  alias FaithfulWordApi.LanguageIdentifierView

  def render("index.json", %{languageidentifier: languageidentifier}) do
    %{data: render_many(languageidentifier, LanguageIdentifierView, "language_identifier.json")}
  end

  def render("show.json", %{language_identifier: language_identifier}) do
    %{data: render_one(language_identifier, LanguageIdentifierView, "language_identifier.json")}
  end

  def render("language_identifier.json", %{language_identifier: language_identifier}) do
    %{id: language_identifier.id,
      uuid: language_identifier.uuid,
      identifier: language_identifier.identifier,
      source_material: language_identifier.source_material,
      supported: language_identifier.supported}
  end
end
