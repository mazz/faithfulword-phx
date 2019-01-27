defmodule FaithfulWordApi.MediaChapterView do
  use FaithfulWordApi, :view
  alias FaithfulWordApi.MediaChapterView

  def render("index.json", %{mediachapter: mediachapter, api_version: api_version}) do
    %{result: render_many(mediachapter, MediaChapterView, "media_chapter.json"),
    status: "success",
    version: api_version}

    # %{data: render_many(mediachapter, MediaChapterView, "media_chapter.json")}
  end

  def render("show.json", %{media_chapter: media_chapter}) do
    %{data: render_one(media_chapter, MediaChapterView, "media_chapter.json")}
  end

  def render("media_chapter.json", %{media_chapter: media_chapter}) do
    %{localizedName: media_chapter.localizedName, path: media_chapter.path, presenterName: media_chapter.presenterName, sourceMaterial: media_chapter.sourceMaterial, uuid: media_chapter.uuid}
  end
end
