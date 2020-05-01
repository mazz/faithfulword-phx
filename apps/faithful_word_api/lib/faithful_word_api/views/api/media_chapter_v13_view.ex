defmodule FaithfulWordApi.MediaChapterV13View do
  use FaithfulWordApi, :view
  alias FaithfulWordApi.MediaChapterV13View

  def render("indexv13.json", %{media_chapter_v13: media_chapter_v13, api_version: api_version}) do
    %{
      result: render_many(media_chapter_v13, MediaChapterV13View, "media_chapter_v13.json"),
      page_number: media_chapter_v13.page_number,
      page_size: media_chapter_v13.page_size,
      status: "success",
      total_entries: media_chapter_v13.total_entries,
      total_pages: media_chapter_v13.total_pages,
      version: api_version
    }

    # %{data: render_many(media_chapter_v13, MediaChapterV13View, "media_chapter_v13.json")}
  end

  def render("show.json", %{media_chapter_v13: media_chapter_v13}) do
    %{data: render_one(media_chapter_v13, MediaChapterV13View, "media_chapter_v13.json")}
  end

  def render("media_chapter_v13.json", %{media_chapter_v13: media_chapter_v13}) do
    %{
      localizedName: media_chapter_v13.localizedName,
      path: media_chapter_v13.path,
      presenterName: media_chapter_v13.presenterName,
      sourceMaterial: media_chapter_v13.sourceMaterial,
      uuid: media_chapter_v13.uuid
    }
  end
end
