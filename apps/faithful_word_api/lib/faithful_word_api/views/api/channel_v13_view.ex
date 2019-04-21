defmodule FaithfulWordApi.ChannelV13View do
  use FaithfulWordApi, :view
  alias FaithfulWordApi.ChannelV13View

  require Logger

  def render("indexv13.json", %{channel_v13: channel_v13, api_version: api_version}) do
    %{result: render_many(channel_v13, ChannelV13View, "channel_v13.json"),
    pageNumber: channel_v13.page_number,
    pageSize: channel_v13.page_size,
    status: "success",
    totalEntries: channel_v13.total_entries,
    totalPages: channel_v13.total_pages,
    version: api_version}
  end

  def render("show.json", %{channel_v13: channel_v13}) do
    %{data: render_one(channel_v13, ChannelV13View, "channel_v13.json")}
  end

  def render("channel_v13.json", %{channel_v13: channel_v13}) do
    # {"Revelation", "Apocalipse", "2c22a08a-80ee-4ec1-be94-f018892fe8ba", "pt"}
    # {b.basename, title.localizedname, b.uuid, title.language_id}
    Logger.debug("book #{inspect %{attributes: channel_v13}}")

    %{basename: channel_v13.basename,
      uuid: channel_v13.uuid,
      ordinal: channel_v13.ordinal,
      smallThumbnailPath: channel_v13.small_thumbnail_path,
      medThumbnailPath: channel_v13.med_thumbnail_path,
      largeThumbnailPath: channel_v13.large_thumbnail_path,
      bannerPath: channel_v13.banner_path,
      insertedAt: channel_v13.insertedAt,
      updatedAt: channel_v13.updatedAt
    }
  end
end

