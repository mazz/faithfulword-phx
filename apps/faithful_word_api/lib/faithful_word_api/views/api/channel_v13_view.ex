defmodule FaithfulWordApi.ChannelV13View do
  use FaithfulWordApi, :view
  alias FaithfulWordApi.ChannelV13View

  require Logger

  def render("addv13.json", %{channel_v13: channel_v13, api_version: api_version}) do
    Logger.debug("render channel_v13 #{inspect(%{attributes: channel_v13})}")
    %{result: channel_v13, status: "success", version: api_version}
  end

  def render("addv13.json", %{add_channel_v13: add_channel_v13}) do
    %{add_channel_v13: add_channel_v13}
  end

  def render("channelsv13.json", %{channel_v13: channel_v13, api_version: api_version}) do
    %{
      result: render_many(channel_v13, ChannelV13View, "channel_v13.json"),
      page_number: channel_v13.page_number,
      page_size: channel_v13.page_size,
      status: "success",
      total_entries: channel_v13.total_entries,
      total_pages: channel_v13.total_pages,
      version: api_version
    }
  end

  def render("show.json", %{channel_v13: channel_v13}) do
    %{data: render_one(channel_v13, ChannelV13View, "channel_v13.json")}
  end

  def render("channel_v13.json", %{channel_v13: channel_v13}) do
    Logger.debug("channel #{inspect(%{attributes: channel_v13})}")

    %{
      basename: channel_v13.basename,
      uuid: channel_v13.uuid,
      org_uuid: channel_v13.org_uuid,
      ordinal: channel_v13.ordinal,
      small_thumbnail_path: channel_v13.small_thumbnail_path,
      med_thumbnail_path: channel_v13.med_thumbnail_path,
      large_thumbnail_path: channel_v13.large_thumbnail_path,
      banner_path: channel_v13.banner_path,
      hash_id: channel_v13.hash_id,
      inserted_at: channel_v13.inserted_at , #, ## |> render_unix_timestamp(),
      updated_at: channel_v13.updated_at# |> render_unix_timestamp()
    }
  end

  defp render_unix_timestamp(nil), do: nil
  defp render_unix_timestamp(datetime), do: DateTime.to_unix(datetime, :second)
end
