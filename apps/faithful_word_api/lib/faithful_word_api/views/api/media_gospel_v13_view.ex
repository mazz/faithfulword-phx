defmodule FaithfulWordApi.MediaGospelV13View do
  use FaithfulWordApi, :view
  alias FaithfulWordApi.MediaGospelV13View

  def render("indexv13.json", %{media_gospel_v13: media_gospel_v13, api_version: api_version}) do
    %{
      result: render_many(media_gospel_v13, MediaGospelV13View, "media_gospel_v13.json"),
      page_number: media_gospel_v13.page_number,
      page_size: media_gospel_v13.page_size,
      status: "success",
      total_entries: media_gospel_v13.total_entries,
      total_pages: media_gospel_v13.total_pages,
      version: api_version
    }

    # %{data: render_many(media_gospel_v13, MediaGospelV13View, "media_gospel_v13.json")}
  end

  def render("show.json", %{media_gospel_v13: media_gospel_v13}) do
    %{data: render_one(media_gospel_v13, MediaGospelV13View, "media_gospel_v13.json")}
  end

  def render("media_gospel_v13.json", %{media_gospel_v13: media_gospel_v13}) do
    %{
      localizedName: media_gospel_v13.localizedName,
      path: media_gospel_v13.path,
      presenterName: media_gospel_v13.presenterName,
      sourceMaterial: media_gospel_v13.sourceMaterial,
      uuid: media_gospel_v13.uuid
    }
  end
end
