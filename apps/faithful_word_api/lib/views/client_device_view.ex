defmodule FaithfulWordApi.ClientDeviceView do
  use FaithfulWordApi, :view
  alias FaithfulWordApi.ClientDeviceView
  require Logger

  def render("index.json", %{client_device: client_device, api_version: api_version}) do
    Logger.debug("render client_device #{inspect %{attributes: client_device}}")
    %{result: [],
    status: "success",
    version: api_version}
  end

  def render("show.json", %{client_device: client_device}) do
    %{data: render_one(client_device, ClientDeviceView, "client_device.json")}
  end

  def render("client_device.json", %{client_device: client_device}) do
    %{client_device: client_device}
  end
end
