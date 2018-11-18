defmodule FaithfulWordApi.GospelView do
  use FaithfulWordApi, :view
  alias FaithfulWordApi.GospelView

  def render("index.json", %{gospel: gospel}) do
    %{data: render_many(gospel, GospelView, "gospel.json")}
  end

  def render("show.json", %{gospel: gospel}) do
    %{data: render_one(gospel, GospelView, "gospel.json")}
  end

  def render("gospel.json", %{gospel: gospel}) do
    %{id: gospel.id,
      absolute_id: gospel.absolute_id,
      uuid: gospel.uuid,
      basename: gospel.basename}
  end
end
