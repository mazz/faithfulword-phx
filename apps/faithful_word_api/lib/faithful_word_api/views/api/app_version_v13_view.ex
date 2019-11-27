defmodule FaithfulWordApi.AppVersionV13View do
  use FaithfulWordApi, :view
  alias FaithfulWordApi.AppVersionV13View

  def render("indexv13.json", %{app_version_v13: app_version_v13, api_version: api_version}) do
    %{
      result: render_many(app_version_v13, AppVersionV13View, "app_version_v13.json"),
      page_number: app_version_v13.page_number,
      page_size: app_version_v13.page_size,
      status: "success",
      total_entries: app_version_v13.total_entries,
      total_pages: app_version_v13.total_pages,
      version: api_version
    }
  end

  def render("show.json", %{app_version_v13: app_version_v13}) do
    %{data: render_one(app_version_v13, AppVersionV13View, "app_version_v13.json")}
  end

  def render("app_version_v13.json", %{app_version_v13: app_version_v13}) do
    %{
      uuid: app_version_v13.uuid,
      version_number: app_version_v13.version_number,
      ios_supported: app_version_v13.ios_supported,
      android_supported: app_version_v13.android_supported,
      web_supported: app_version_v13.web_supported
    }
  end
end
