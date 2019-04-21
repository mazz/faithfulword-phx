defmodule FaithfulWordApi.PlaylistV13View do
  use FaithfulWordApi, :view
  alias FaithfulWordApi.PlaylistV13View

  def render("indexv13.json", %{playlist_v13: playlist_v13, api_version: api_version}) do
    %{result: render_many(playlist_v13, PlaylistV13View, "playlist_v13.json"),
    pageNumber: playlist_v13.page_number,
    pageSize: playlist_v13.page_size,
    status: "success",
    totalEntries: playlist_v13.total_entries,
    totalPages: playlist_v13.total_pages,
    version: api_version}

    # %{data: render_many(playlist_v13, PlaylistV13View, "playlist_v13.json")}
  end

  def render("show.json", %{playlist_v13: playlist_v13}) do
    %{data: render_one(playlist_v13, PlaylistV13View, "playlist_v13.json")}
  end

  def render("playlist_v13.json", %{playlist_v13: playlist_v13}) do
    %{localizedname: playlist_v13.localizedname,
      uuid: playlist_v13.uuid,
      ordinal: playlist_v13.ordinal,
      smallThumbnailPath: playlist_v13.small_thumbnail_path,
      medThumbnailPath: playlist_v13.med_thumbnail_path,
      largeThumbnailPath: playlist_v13.large_thumbnail_path,
      bannerPath: playlist_v13.banner_path,
      insertedAt: playlist_v13.inserted_at,
      updatedAt: playlist_v13.updated_at
    }
  end
end

