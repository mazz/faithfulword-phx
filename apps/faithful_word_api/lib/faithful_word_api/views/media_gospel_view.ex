defmodule FaithfulWordApi.MediaGospelView do
  use FaithfulWordApi, :view
  alias FaithfulWordApi.MediaGospelView

  def render("index.json", %{mediagospel: mediagospel}) do
    %{data: render_many(mediagospel, MediaGospelView, "media_gospel.json")}
  end

  def render("show.json", %{media_gospel: media_gospel}) do
    %{data: render_one(media_gospel, MediaGospelView, "media_gospel.json")}
  end

  def render("media_gospel.json", %{media_gospel: media_gospel}) do
    %{id: media_gospel.id,
      absolute_id: media_gospel.absolute_id,
      uuid: media_gospel.uuid,
      track_number: media_gospel.track_number,
      localizedname: media_gospel.localizedname,
      path: media_gospel.path,
      language_id: media_gospel.language_id,
      presenter_name: media_gospel.presenter_name,
      source_material: media_gospel.source_material}
  end
end
