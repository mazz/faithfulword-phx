defmodule FaithfulWordApi.MediaMusicV13View do
  use FaithfulWordApi, :view
  alias FaithfulWordApi.MediaMusicV13View

  def render("indexv13.json", %{media_music_v13: media_music_v13, api_version: api_version}) do
    %{
      result: render_many(media_music_v13, MediaMusicV13View, "media_music_v13.json"),
      page_number: media_music_v13.page_number,
      page_size: media_music_v13.page_size,
      status: "success",
      total_entries: media_music_v13.total_entries,
      total_pages: media_music_v13.total_pages,
      version: api_version
    }

    # %{data: render_many(media_music_v13, MediaMusicV13View, "media_music_v13.json")}
  end

  def render("show.json", %{media_music_v13: media_music_v13}) do
    %{data: render_one(media_music_v13, MediaMusicV13View, "media_music_v13.json")}
  end

  def render("media_music_v13.json", %{media_music_v13: media_music_v13}) do
    %{
      localizedName: media_music_v13.localizedName,
      path: media_music_v13.path,
      presenterName: media_music_v13.presenterName,
      sourceMaterial: media_music_v13.sourceMaterial,
      uuid: media_music_v13.uuid
    }
  end
end
