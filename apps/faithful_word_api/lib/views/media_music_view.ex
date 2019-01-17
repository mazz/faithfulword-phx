defmodule FaithfulWordApi.MediaMusicView do
  use FaithfulWordApi, :view
  alias FaithfulWordApi.MediaMusicView

  def render("index.json", %{mediamusic: mediamusic}) do
    %{data: render_many(mediamusic, MediaMusicView, "media_music.json")}
  end

  def render("show.json", %{media_music: media_music}) do
    %{data: render_one(media_music, MediaMusicView, "media_music.json")}
  end

  def render("media_music.json", %{media_music: media_music}) do
    %{id: media_music.id,
      absolute_id: media_music.absolute_id,
      uuid: media_music.uuid,
      track_number: media_music.track_number,
      localizedname: media_music.localizedname,
      path: media_music.path,
      language_id: media_music.language_id,
      presenter_name: media_music.presenter_name,
      source_material: media_music.source_material}
  end
end
