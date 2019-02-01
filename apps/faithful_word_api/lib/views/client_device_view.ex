defmodule FaithfulWordApi.ClientDeviceView do
  use FaithfulWordApi, :view
  alias FaithfulWordApi.ClientDeviceView

  def render("index.json", %{client_device: client_device, api_version: api_version}) do
    %{result: render_many(client_device, ClientDeviceView, "client_device.json"),
    pageNumber: client_device.page_number,
    pageSize: client_device.page_size,
    status: "success",
    totalEntries: client_device.total_entries,
    totalPages: client_device.total_pages,
    version: api_version}
  end

  def render("show.json", %{client_device: client_device}) do
    %{data: render_one(client_device, ClientDeviceView, "client_device.json")}
  end

  def render("client_device.json", %{client_device: client_device}) do
    %{}
  end
end
