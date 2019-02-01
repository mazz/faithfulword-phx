defmodule FaithfulWordApi.AppVersionView do
  use FaithfulWordApi, :view
  alias FaithfulWordApi.AppVersionView

  def render("index.json", %{app_version: app_version, api_version: api_version}) do
    %{result: render_many(app_version, AppVersionView, "app_version.json"),
    pageNumber: app_version.page_number,
    pageSize: app_version.page_size,
    status: "success",
    totalEntries: app_version.total_entries,
    totalPages: app_version.total_pages,
    version: api_version}
  end

  def render("show.json", %{app_version: app_version}) do
    %{data: render_one(app_version, AppVersionView, "app_version.json")}
  end

  def render("app_version.json", %{app_version: app_version}) do
    %{uuid: app_version.uuid,
      versionNumber: app_version.version_number,
      iosSupported: app_version.ios_supported,
      androidSupported: app_version.android_supported}
  end
end
