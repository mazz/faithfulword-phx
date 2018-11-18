defmodule FaithfulWordApi.ClientDeviceController do
  use FaithfulWordApi, :controller

  alias FaithfulWord.Analytics
  alias FaithfulWord.Analytics.ClientDevice

  action_fallback FaithfulWordApi.FallbackController

  def index(conn, _params) do
    clientdevice = Analytics.list_clientdevice()
    render(conn, "index.json", clientdevice: clientdevice)
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
