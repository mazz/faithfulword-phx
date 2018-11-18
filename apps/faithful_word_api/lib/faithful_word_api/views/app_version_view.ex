defmodule FaithfulWordApi.AppVersionView do
  use FaithfulWordApi, :view
  alias FaithfulWordApi.AppVersionView

  def render("index.json", %{appversion: appversion}) do
    %{data: render_many(appversion, AppVersionView, "app_version.json")}
  end

  def render("show.json", %{app_version: app_version}) do
    %{data: render_one(app_version, AppVersionView, "app_version.json")}
  end

  def render("app_version.json", %{app_version: app_version}) do
    %{id: app_version.id,
      uuid: app_version.uuid,
      version_number: app_version.version_number,
      ios_supported: app_version.ios_supported,
      android_supported: app_version.android_supported}
  end
end
