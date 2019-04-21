defmodule FaithfulWordApi.MediaItemV13View do
  use FaithfulWordApi, :view
  alias FaithfulWordApi.MediaItemV13View

  def render("indexv13.json",%{media_item_v13: media_item_v13, api_version: api_version}) do
    %{result: render_many(media_item_v13, MediaItemV13View, "media_item_v13.json"),
    pageNumber: media_item_v13.page_number,
    pageSize: media_item_v13.page_size,
    status: "success",
    totalEntries: media_item_v13.total_entries,
    totalPages: media_item_v13.total_pages,
    version: api_version}
    # %{data: render_many(media_item_v13, MediaItemV13View, "media_item_v13.json")}
  end

  def render("show.json", %{media_item_v13: media_item_v13}) do
    %{data: render_one(media_item_v13, MediaItemV13View, "media_item_v13.json")}
  end

  def render("media_item_v13.json", %{media_item_v13: media_item_v13}) do
    # %{localizedName: media_item_v13.localizedName,
    # path: media_item_v13.path,
    # presenterName: media_item_v13.presenterName,
    # sourceMaterial: media_item_v13.sourceMaterial,
    # uuid: media_item_v13.uuid}
    %{ordinal: media_item_v13.ordinal,
      uuid: media_item_v13.uuid,
      trackNumber: media_item_v13.track_number,
      medium: media_item_v13.medium,
      localizedname: media_item_v13.localizedname,
      path: media_item_v13.path,
      contentProviderLink: media_item_v13.content_provider_link,
      ipfsLink: media_item_v13.ipfs_link,
      languageId: media_item_v13.language_id,
      presenterName: media_item_v13.presenter_name,
      sourceMaterial: media_item_v13.source_material,
      playlistId: media_item_v13.playlist_id,
      tags: media_item_v13.tags,
      smallThumbnailPath: media_item_v13.small_thumbnail_path,
      medThumbnailPath: media_item_v13.med_thumbnail_path,
      largeThumbnailPath: media_item_v13.large_thumbnail_path,
      insertedAt: media_item_v13.inserted_at,
      updatedAt: media_item_v13.updated_at}
  end
end

"""
%{ordinal: mm.ordinal,
      uuid: mm.uuid,
      track_number: mm.track_number,
      medium: mm.medium,
      localizedname: mm.localizedname,
      path: mm.path,
      content_provider_link: mm.content_provider_link,
      ipfs_link: mm.ipfs_link,
      language_id: mm.language_id,
      presenter_name: mm.presenter_name,
      source_material: mm.source_material,
      playlist_id: mm.playlist_id,
      tags: mm.tags,
      small_thumbnail_path: mm.small_thumbnail_path,
      med_thumbnail_path: mm.med_thumbnail_path,
      large_thumbnail_path: mm.large_thumbnail_path,
      banner_path: mm.banner_path,
      inserted_at: mm.inserted_at,
      updated_at: mm.updated_at}
      """
