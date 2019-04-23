defmodule FaithfulWordApi.SearchV13View do
  use FaithfulWordApi, :view
  alias FaithfulWordApi.SearchV13View

  def render("indexv13.json", %{search_v13: search_v13, api_version: api_version}) do
    %{result: render_many(search_v13, SearchV13View, "search_v13.json"),
    pageNumber: search_v13.page_number,
    pageSize: search_v13.page_size,
    status: "success",
    totalEntries: search_v13.total_entries,
    totalPages: search_v13.total_pages,
    version: api_version}

    # %{data: render_many(search_v13, SearchV13View, "search_v13.json")}
  end

  def render("show.json", %{search_v13: search_v13}) do
    %{data: render_one(search_v13, SearchV13View, "search_v13.json")}
  end

  def render("search_v13.json", %{search_v13: search_v13}) do
    %{localizedname: search_v13.localizedname,
      uuid: search_v13.uuid,
      ordinal: search_v13.ordinal,
      smallThumbnailPath: search_v13.small_thumbnail_path,
      medThumbnailPath: search_v13.med_thumbnail_path,
      largeThumbnailPath: search_v13.large_thumbnail_path,
      bannerPath: search_v13.banner_path,
      mediaCategory: search_v13.media_category,
      insertedAt: search_v13.inserted_at,
      updatedAt: search_v13.updated_at
    }
  end
end

