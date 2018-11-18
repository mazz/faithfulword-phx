defmodule FaithfulWordApi.ClientDeviceView do
  use FaithfulWordApi, :view
  alias FaithfulWordApi.ClientDeviceView

  def render("index.json", %{clientdevice: clientdevice}) do
    %{data: render_many(clientdevice, ClientDeviceView, "client_device.json")}
  end

  def render("show.json", %{client_device: client_device}) do
    %{data: render_one(client_device, ClientDeviceView, "client_device.json")}
  end

  def render("client_device.json", %{client_device: client_device}) do
    %{id: client_device.id,
      uuid: client_device.uuid,
      firebase_token: client_device.firebase_token,
      apns_token: client_device.apns_token,
      preferred_language: client_device.preferred_language,
      user_agent: client_device.user_agent}
  end
end
