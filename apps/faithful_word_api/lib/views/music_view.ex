defmodule FaithfulWordApi.MusicView do
  use FaithfulWordApi, :view
  alias FaithfulWordApi.MusicView

  def render("index.json", %{music: music, api_version: api_version}) do
    %{result: render_many(music, MusicView, "music.json"),
    pageNumber: music.page_number,
    pageSize: music.page_size,
    status: "success",
    totalEntries: music.total_entries,
    totalPages: music.total_pages,
    version: api_version}
  end

  def render("show.json", %{music: music}) do
    %{data: render_one(music, MusicView, "music.json")}
  end

  def render("music.json", %{music: music}) do
    %{title: music.title,
    localizedTitle: music.localizedTitle,
    uuid: music.uuid,
    languageId: music.languageId}
  end
end
# %{music: music, api_version: api_version}
