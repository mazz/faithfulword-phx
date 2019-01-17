defmodule FaithfulWordApi.AppVersionController do
  use FaithfulWordApi, :controller

  alias FaithfulWord.Analytics
  alias FaithfulWord.Analytics.AppVersion

  action_fallback FaithfulWordApi.FallbackController

  def index(conn, _params) do
    appversion = Analytics.list_appversion()
    render(conn, "index.json", appversion: appversion)
  end

  def create(conn, %{"app_version" => app_version_params}) do
    with {:ok, %AppVersion{} = app_version} <- Analytics.create_app_version(app_version_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.app_version_path(conn, :show, app_version))
      |> render("show.json", app_version: app_version)
    end
  end

  def show(conn, %{"id" => id}) do
    app_version = Analytics.get_app_version!(id)
    render(conn, "show.json", app_version: app_version)
  end

  def update(conn, %{"id" => id, "app_version" => app_version_params}) do
    app_version = Analytics.get_app_version!(id)

    with {:ok, %AppVersion{} = app_version} <- Analytics.update_app_version(app_version, app_version_params) do
      render(conn, "show.json", app_version: app_version)
    end
  end

  def delete(conn, %{"id" => id}) do
    app_version = Analytics.get_app_version!(id)

    with {:ok, %AppVersion{}} <- Analytics.delete_app_version(app_version) do
      send_resp(conn, :no_content, "")
    end
  end
end
