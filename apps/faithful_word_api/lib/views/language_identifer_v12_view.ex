defmodule FaithfulWordApi.LanguageIdentifierV12View do
  use FaithfulWordApi, :view
  alias FaithfulWordApi.LanguageIdentifierV12View

  def render("indexv12.json",%{language_identifier_v12: language_identifier_v12}) do
    %{result: render_many(language_identifier_v12, LanguageIdentifierV12View, "language_identifier_v12.json"),
    status: "success",
    version: "v1.2"}
    # %{data: render_many(language_identifier_v12, LanguageIdentifierV12View, "language_identifier_v12.json")}
  end

  def render("show.json", %{language_identifier_v12: language_identifier_v12}) do
    %{data: render_one(language_identifier_v12, LanguageIdentifierV12View, "language_identifier_v12.json")}
  end

  def render("language_identifier_v12.json", %{language_identifier_v12: language_identifier_v12}) do
    %{identifier: language_identifier_v12.identifier, source_material: language_identifier_v12.source_material, supported: language_identifier_v12.supported, uuid: language_identifier_v12.uuid}
  end
end
