defmodule FaithfulWordApi.PlaylistV13View do
  use FaithfulWordApi, :view
  alias FaithfulWordApi.PlaylistV13View

  require Logger

  def render("addv13.json", %{playlist_v13: playlist_v13, api_version: api_version}) do
    Logger.debug("render playlist_v13 #{inspect(%{attributes: playlist_v13})}")

    playlist_map = %{
      # hash_id: task_v10.rubric.hash_id,
      basename: playlist_v13.basename,
      # languageId: playlist_v13.language_id,
      uuid: playlist_v13.uuid,
      channel_id: playlist_v13.channel_id,
      ordinal: playlist_v13.ordinal,
      small_thumbnail_path: playlist_v13.small_thumbnail_path,
      med_thumbnail_path: playlist_v13.med_thumbnail_path,
      large_thumbnail_path: playlist_v13.large_thumbnail_path,
      banner_path: playlist_v13.banner_path,
      media_category: playlist_v13.media_category,
      hash_id: playlist_v13.hash_id,
      inserted_at: playlist_v13.inserted_at,# |> render_unix_timestamp(),
      updated_at: playlist_v13.updated_at# |> render_unix_timestamp()
    }

    %{result: playlist_map, status: "success", version: api_version}
  end

  def render("addv13.json", %{add_playlist_v13: add_playlist_v13}) do
    %{add_playlist_v13: add_playlist_v13}
  end

  def render("indexv13.json", %{playlist_v13: playlist_v13, api_version: api_version}) do
    %{
      result: render_many(playlist_v13, PlaylistV13View, "playlist_v13.json"),
      pageNumber: playlist_v13.page_number,
      pageSize: playlist_v13.page_size,
      status: "success",
      totalEntries: playlist_v13.total_entries,
      totalPages: playlist_v13.total_pages,
      version: api_version
    }

    # %{data: render_many(playlist_v13, PlaylistV13View, "playlist_v13.json")}
  end

  def render("show.json", %{playlist_v13: playlist_v13}) do
    %{data: render_one(playlist_v13, PlaylistV13View, "playlist_v13.json")}
  end

  def render("playlist_v13.json", %{playlist_v13: playlist_v13}) do
    %{
      localizedname: playlist_v13.localizedname,
      languageId: playlist_v13.language_id,
      uuid: playlist_v13.uuid,
      channelUuid: playlist_v13.channel_uuid,
      ordinal: playlist_v13.ordinal,
      smallThumbnailPath: playlist_v13.small_thumbnail_path,
      medThumbnailPath: playlist_v13.med_thumbnail_path,
      largeThumbnailPath: playlist_v13.large_thumbnail_path,
      bannerPath: playlist_v13.banner_path,
      mediaCategory: playlist_v13.media_category,
      hashId: playlist_v13.hash_id,
      insertedAt: playlist_v13.inserted_at |> render_unix_timestamp(),
      updatedAt: playlist_v13.updated_at |> render_unix_timestamp()
    }
  end

  defp render_unix_timestamp(nil), do: nil
  defp render_unix_timestamp(datetime), do: DateTime.to_unix(datetime, :second)
end
