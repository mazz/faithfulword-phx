defmodule FaithfulWordApi.ClientDeviceV12View do
  use FaithfulWordApi, :view
  alias FaithfulWordApi.ClientDeviceV12View

  def render("indexv12.json", %{client_device_v12: client_device_v12, api_version: api_version}) do
    %{result: render_many(client_device_v12, ClientDeviceV12View, "client_device_v12.json"),
    pageNumber: client_device_v12.page_number,
    pageSize: client_device_v12.page_size,
    status: "success",
    totalEntries: client_device_v12.total_entries,
    totalPages: client_device_v12.total_pages,
    version: api_version}
  end

  def render("show.json", %{client_device_v12: client_device_v12}) do
    %{data: render_one(client_device_v12, ClientDeviceV12View, "client_device_v12.json")}
  end

  def render("client_device_v12.json", %{client_device_v12: client_device_v12}) do
    %{}
  end
end
