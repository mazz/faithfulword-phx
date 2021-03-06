defmodule FaithfulWordApi.MediaItemV13View do
  use FaithfulWordApi, :view
  alias FaithfulWordApi.MediaItemV13View

  require Logger

  def render("addv13.json", %{media_item_v13: media_item_v13, api_version: api_version}) do
    Logger.debug("render media_item_v13 #{inspect(%{attributes: media_item_v13})}")

    media_item_map = %{
      ordinal: media_item_v13.ordinal,
      uuid: media_item_v13.uuid,
      track_number: media_item_v13.track_number,
      medium: media_item_v13.medium,
      localizedname: media_item_v13.localizedname,
      # multilanguage: media_item_v13.multilanguage,
      path: media_item_v13.path,
      content_provider_link: media_item_v13.content_provider_link,
      ipfs_link: media_item_v13.ipfs_link,
      language_id: media_item_v13.language_id,
      presenter_name: media_item_v13.presenter_name,
      source_material: media_item_v13.source_material,
      playlist_id: media_item_v13.playlist_id,
      # playlist_uuid: media_item_v13.playlist_uuid,
      # multilanguage: media_item_v13.multilanguage,
      tags: media_item_v13.tags,
      small_thumbnail_path: media_item_v13.small_thumbnail_path,
      med_thumbnail_path: media_item_v13.med_thumbnail_path,
      large_thumbnail_path: media_item_v13.large_thumbnail_path,
      hash_id: media_item_v13.hash_id,
      duration: media_item_v13.duration,
      ## |> render_unix_timestamp(),
      inserted_at: media_item_v13.inserted_at,
      ## |> render_unix_timestamp(),
      updated_at: media_item_v13.updated_at,
      media_category: media_item_v13.media_category,
      ## |> render_unix_timestamp(),
      presented_at: media_item_v13.presented_at,
      # |> render_unix_timestamp()
      published_at: media_item_v13.published_at
    }

    %{result: media_item_map, status: "success", version: api_version}
  end

  def render("addv13.json", %{add_media_item_v13: add_media_item_v13}) do
    %{add_media_item_v13: add_media_item_v13}
  end

  def render("deletev13.json", %{media_item_v13: media_item_v13, api_version: api_version}) do
    Logger.debug("render media_item_v13 #{inspect(%{attributes: media_item_v13})}")

    media_item_map = %{
      ordinal: media_item_v13.ordinal,
      uuid: media_item_v13.uuid,
      track_number: media_item_v13.track_number,
      medium: media_item_v13.medium,
      localizedname: media_item_v13.localizedname,
      # multilanguage: media_item_v13.multilanguage,
      path: media_item_v13.path,
      content_provider_link: media_item_v13.content_provider_link,
      ipfs_link: media_item_v13.ipfs_link,
      language_id: media_item_v13.language_id,
      presenter_name: media_item_v13.presenter_name,
      source_material: media_item_v13.source_material,
      playlist_id: media_item_v13.playlist_id,
      # playlist_uuid: media_item_v13.playlist_uuid,
      # multilanguage: media_item_v13.multilanguage,
      tags: media_item_v13.tags,
      small_thumbnail_path: media_item_v13.small_thumbnail_path,
      med_thumbnail_path: media_item_v13.med_thumbnail_path,
      large_thumbnail_path: media_item_v13.large_thumbnail_path,
      hash_id: media_item_v13.hash_id,
      duration: media_item_v13.duration,
      ## |> render_unix_timestamp(),
      inserted_at: media_item_v13.inserted_at,
      ## |> render_unix_timestamp(),
      updated_at: media_item_v13.updated_at,
      media_category: media_item_v13.media_category,
      ## |> render_unix_timestamp(),
      presented_at: media_item_v13.presented_at,
      # |> render_unix_timestamp()
      published_at: media_item_v13.published_at
    }

    %{result: media_item_map, status: "success", version: api_version}
  end

  def render("deletev13.json", %{delete_media_item_v13: delete_media_item_v13}) do
    %{delete_media_item_v13: delete_media_item_v13}
  end

  def render("indexv13.json", %{media_item_v13: media_item_v13, api_version: api_version}) do
    %{
      result: render_many(media_item_v13, MediaItemV13View, "media_item_v13.json"),
      page_number: media_item_v13.page_number,
      page_size: media_item_v13.page_size,
      status: "success",
      total_entries: media_item_v13.total_entries,
      total_pages: media_item_v13.total_pages,
      version: api_version
    }

    # %{data: render_many(media_item_v13, MediaItemV13View, "media_item_v13.json")}
  end

  def render("show.json", %{media_item_v13: media_item_v13}) do
    %{data: render_one(media_item_v13, MediaItemV13View, "media_item_v13.json")}
  end

  def render("media_item_v13.json", %{media_item_v13: media_item_v13}) do
    %{
      ordinal: media_item_v13.ordinal,
      uuid: media_item_v13.uuid,
      track_number: media_item_v13.track_number,
      medium: media_item_v13.medium,
      localizedname: media_item_v13.localizedname,
      # multilanguage: media_item_v13.multilanguage,
      path: media_item_v13.path,
      content_provider_link: media_item_v13.content_provider_link,
      ipfs_link: media_item_v13.ipfs_link,
      language_id: media_item_v13.language_id,
      presenter_name: media_item_v13.presenter_name,
      source_material: media_item_v13.source_material,
      playlist_id: media_item_v13.playlist_id,
      # playlist_uuid: media_item_v13.playlist_uuid,
      # multilanguage: media_item_v13.multilanguage,
      tags: media_item_v13.tags,
      small_thumbnail_path: media_item_v13.small_thumbnail_path,
      med_thumbnail_path: media_item_v13.med_thumbnail_path,
      large_thumbnail_path: media_item_v13.large_thumbnail_path,
      hash_id: media_item_v13.hash_id,
      duration: media_item_v13.duration,
      ## |> render_unix_timestamp(),
      inserted_at: media_item_v13.inserted_at,
      ## |> render_unix_timestamp(),
      updated_at: media_item_v13.updated_at,
      media_category: media_item_v13.media_category,
      ## |> render_unix_timestamp(),
      presented_at: media_item_v13.presented_at,
      # |> render_unix_timestamp()
      published_at: media_item_v13.published_at
    }
  end

  defp render_unix_timestamp(nil), do: nil
  defp render_unix_timestamp(datetime), do: DateTime.to_unix(datetime, :second)
end
