defmodule FaithfulWordApi.GospelView do
  use FaithfulWordApi, :view
  alias FaithfulWordApi.GospelView


  def render("index.json", %{gospel: gospel, api_version: api_version}) do
    %{result: render_many(gospel, GospelView, "gospel.json"),
      status: "success",
      version: api_version}
  end

  def render("show.json", %{gospel: gospel}) do
    %{data: render_one(gospel, GospelView, "gospel.json")}
  end

  def render("gospel.json", %{gospel: gospel}) do
    %{title: gospel.title,
    localizedTitle: gospel.localizedTitle,
    uuid: gospel.uuid,
    languageId: gospel.languageId}
  end
end
