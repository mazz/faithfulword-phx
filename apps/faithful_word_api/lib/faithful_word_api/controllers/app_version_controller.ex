defmodule FaithfulWordApi.AppVersionController do
  use FaithfulWordApi, :controller

  alias DB.Schema
  alias DB.Schema.AppVersion
  alias FaithfulWordApi.AppVersionView
  alias FaithfulWordApi.AppVersionV12View
  alias FaithfulWordApi.V12
  alias FaithfulWordApi.V13

  require Logger

  action_fallback FaithfulWordApi.FallbackController

  def indexv12(conn, _params) do
    V12.app_versions()
    |> case do
      nil ->
        put_status(conn, 403)
        |> render(ErrorView, "403.json", %{message: "language not found in supported list."})
      app_version_v12 ->
        Logger.debug("app_version_v12 #{inspect %{attributes: app_version_v12}}")
        render(conn, AppVersionV12View, "indexv12.json", %{app_version_v12: app_version_v12})
    end
  end

  # def index(conn, %{"language-id" => lang}) do
  def index(conn,  %{"offset" => offset, "limit" => limit}) do
    V13.app_versions(offset, limit)
    |>
    case do
      nil ->
        put_status(conn, 403)
        |> render(ErrorView, "403.json", %{message: "language not found in supported list."})
      app_version ->
        # render(conn, GospelView, "index.json", %{app_version: app_version})

        Logger.debug("app_version #{inspect %{attributes: app_version}}")
        Enum.at(conn.path_info, 0)
        |>
        case do
          api_version ->
            api_version = String.trim_leading(api_version, "v")
            render(conn, AppVersionView, "index.json", %{app_version: app_version, api_version: api_version})
        end
    end
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
