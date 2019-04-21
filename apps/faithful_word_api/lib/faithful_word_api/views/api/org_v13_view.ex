defmodule FaithfulWordApi.OrgV13View do
  use FaithfulWordApi, :view
  alias FaithfulWordApi.OrgV13View

  require Logger

  def render("defaultv13.json", %{org_v13: org_v13, api_version: api_version}) do
    %{result: render_many(org_v13, OrgV13View, "org_v13.json"),
    pageNumber: org_v13.page_number,
    pageSize: org_v13.page_size,
    status: "success",
    totalEntries: org_v13.total_entries,
    totalPages: org_v13.total_pages,
    version: api_version}
  end

  def render("show.json", %{org_v13: org_v13}) do
    %{data: render_one(org_v13, OrgV13View, "org_v13.json")}
  end

  def render("org_v13.json", %{org_v13: org_v13}) do
    # {"Revelation", "Apocalipse", "2c22a08a-80ee-4ec1-be94-f018892fe8ba", "pt"}
    # {b.basename, title.localizedname, b.uuid, title.language_id}
    Logger.debug("org #{inspect %{attributes: org_v13}}")

    %{basename: org_v13.basename,
      uuid: org_v13.uuid,
      shortname: org_v13.shortname,
      smallThumbnailPath: org_v13.small_thumbnail_path,
      medThumbnailPath: org_v13.med_thumbnail_path,
      largeThumbnailPath: org_v13.large_thumbnail_path,
      bannerPath: org_v13.banner_path,
      insertedAt: org_v13.insertedAt,
      updatedAt: org_v13.updatedAt
    }
  end
end

"""
select: %{basename: org.basename,
uuid: org.uuid,
small_thumbnail_path: org.small_thumbnail_path,
med_thumbnail_path: org.med_thumbnail_path,
large_thumbnail_path: org.large_thumbnail_path,
banner_path: org.banner_path,
insertedAt: org.inserted_at,
updatedAt: org.updated_at,
shortname: org.shortname,})
"""
