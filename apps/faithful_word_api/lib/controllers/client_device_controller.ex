defmodule FaithfulWordApi.ClientDeviceController do
  use FaithfulWordApi, :controller

  alias DB.Schema
  alias DB.Schema.ClientDevice
  alias FaithfulWordApi.ClientDeviceView
  alias FaithfulWordApi.ClientDeviceV12View
  alias FaithfulWordApi.V12
  alias FaithfulWordApi.V13

  require Logger
  action_fallback FaithfulWordApi.FallbackController

  def indexv12(conn, %{"fcmToken" => fcm_token, "apnsToken" => apns_token, "preferredLanguage" => preferred_language, "userAgent" => user_agent}) do
    Logger.debug("fcm_token #{inspect %{attributes: fcm_token}}")
    V12.add_client_device(fcm_token, apns_token, preferred_language, user_agent)
    |> case do
      nil ->
        put_status(conn, 403)
        |> render(ErrorView, "403.json", %{message: "something happened."})
      client_device_v12 ->
        Logger.debug("client_device_v12 #{inspect %{attributes: client_device_v12}}")
        render(conn, ClientDeviceV12View, "indexv12.json", %{client_device_v12: client_device_v12})
    end
  end

  def index(conn, %{"fcmToken" => fcm_token, "apnsToken" => apns_token, "preferredLanguage" => preferred_language, "userAgent" => user_agent, "userVersion" => user_version}) do
    V13.add_client_device(fcm_token, apns_token, preferred_language, user_agent, user_version)
    |> case do
      nil ->
        put_status(conn, 403)
        |> render(ErrorView, "403.json", %{message: "something happened."})
      client_device ->
        # Logger.debug("client_devices #{inspect %{attributes: client_devices}}")
        Logger.debug("client_device #{inspect %{attributes: client_device}}")
        Enum.at(conn.path_info, 0)
        |> case do
          api_version ->
            Logger.debug("api_version #{inspect %{attributes: api_version}}")
            api_version = String.trim_leading(api_version, "v")
            render(conn, ClientDeviceView, "index.json", %{client_device: client_device, api_version: api_version})
        end
    end
  end

  def create(conn, %{"client_device" => client_device_params}) do
    with {:ok, %ClientDevice{} = client_device} <- Analytics.create_client_device(client_device_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.client_device_path(conn, :show, client_device))
      |> render("show.json", client_device: client_device)
    end
  end

  def show(conn, %{"id" => id}) do
    client_device = Analytics.get_client_device!(id)
    render(conn, "show.json", client_device: client_device)
  end

  def update(conn, %{"id" => id, "client_device" => client_device_params}) do
    client_device = Analytics.get_client_device!(id)

    with {:ok, %ClientDevice{} = client_device} <- Analytics.update_client_device(client_device, client_device_params) do
      render(conn, "show.json", client_device: client_device)
    end
  end

  def delete(conn, %{"id" => id}) do
    client_device = Analytics.get_client_device!(id)

    with {:ok, %ClientDevice{}} <- Analytics.delete_client_device(client_device) do
      send_resp(conn, :no_content, "")
    end
  end
end
