defmodule FaithfulWordApi.MediaMusicView do
  use FaithfulWordApi, :view
  alias FaithfulWordApi.MediaMusicView

  def render("index.json",%{media_music: media_music, api_version: api_version}) do
    %{result: render_many(media_music, MediaMusicView, "media_music.json"),
    pageNumber: media_music.page_number,
    pageSize: media_music.page_size,
    status: "success",
    totalEntries: media_music.total_entries,
    totalPages: media_music.total_pages,
    version: api_version}
    # %{data: render_many(media_music, MediaMusicView, "media_music.json")}
  end

  def render("show.json", %{media_music: media_music}) do
    %{data: render_one(media_music, MediaMusicView, "media_music.json")}
  end

  def render("media_music.json", %{media_music: media_music}) do
    %{localizedName: media_music.localizedName, path: media_music.path, presenterName: media_music.presenterName, sourceMaterial: media_music.sourceMaterial, uuid: media_music.uuid}
  end
end
