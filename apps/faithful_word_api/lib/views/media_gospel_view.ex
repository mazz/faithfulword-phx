defmodule FaithfulWordApi.MediaGospelView do
  use FaithfulWordApi, :view
  alias FaithfulWordApi.MediaGospelView

  def render("index.json",%{mediagospel: mediagospel, api_version: api_version}) do
    %{result: render_many(mediagospel, MediaGospelView, "media_gospel.json"),
    pageNumber: mediagospel.page_number,
    pageSize: mediagospel.page_size,
    status: "success",
    totalEntries: mediagospel.total_entries,
    totalPages: mediagospel.total_pages,
    version: api_version}
    # %{data: render_many(mediagospel, MediaGospelView, "media_gospel.json")}
  end

  def render("show.json", %{media_gospel: media_gospel}) do
    %{data: render_one(media_gospel, MediaGospelView, "media_gospel.json")}
  end

  def render("media_gospel.json", %{media_gospel: media_gospel}) do
    %{localizedName: media_gospel.localizedName, path: media_gospel.path, presenterName: media_gospel.presenterName, sourceMaterial: media_gospel.sourceMaterial, uuid: media_gospel.uuid}
  end
end
