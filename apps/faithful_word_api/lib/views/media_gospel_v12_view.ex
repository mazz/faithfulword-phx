defmodule FaithfulWordApi.MediaGospelV12View do
  use FaithfulWordApi, :view
  alias FaithfulWordApi.MediaGospelV12View

  def render("index.json",%{media_gospel_v12: media_gospel_v12}) do
    %{result: render_many(media_gospel_v12, MediaGospelV12View, "media_gospel_v12.json"),
    status: "success",
    version: "v1.2"}
    # %{data: render_many(media_gospel_v12, MediaGospelV12View, "media_gospel_v12.json")}
  end

  def render("show.json", %{media_gospel_v12: media_gospel_v12}) do
    %{data: render_one(media_gospel_v12, MediaGospelV12View, "media_gospel_v12.json")}
  end

  def render("media_gospel_v12.json", %{media_gospel_v12: media_gospel_v12}) do
    %{localizedName: media_gospel_v12.localizedName, path: media_gospel_v12.path, presenterName: media_gospel_v12.presenterName, sourceMaterial: media_gospel_v12.sourceMaterial, uuid: media_gospel_v12.uuid}
  end
end
