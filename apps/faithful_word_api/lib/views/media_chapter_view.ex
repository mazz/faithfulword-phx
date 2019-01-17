defmodule FaithfulWordApi.MediaChapterView do
  use FaithfulWordApi, :view
  alias FaithfulWordApi.MediaChapterView

  def render("index.json", %{mediachapter: mediachapter}) do
    %{data: render_many(mediachapter, MediaChapterView, "media_chapter.json")}
  end

  def render("show.json", %{media_chapter: media_chapter}) do
    %{data: render_one(media_chapter, MediaChapterView, "media_chapter.json")}
  end

  def render("media_chapter.json", %{media_chapter: media_chapter}) do
    %{id: media_chapter.id,
      absolute_id: media_chapter.absolute_id,
      uuid: media_chapter.uuid,
      track_number: media_chapter.track_number,
      localizedname: media_chapter.localizedname,
      path: media_chapter.path,
      language_id: media_chapter.language_id,
      presenter_name: media_chapter.presenter_name,
      source_material: media_chapter.source_material}
  end
end
