defmodule FaithfulWordApi.MusicView do
  use FaithfulWordApi, :view
  alias FaithfulWordApi.MusicView

  def render("index.json", %{music: music}) do
    %{data: render_many(music, MusicView, "music.json")}
  end

  def render("show.json", %{music: music}) do
    %{data: render_one(music, MusicView, "music.json")}
  end

  def render("music.json", %{music: music}) do
    %{id: music.id,
      absolute_id: music.absolute_id,
      uuid: music.uuid,
      basename: music.basename}
  end
end
