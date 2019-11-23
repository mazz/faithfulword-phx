defmodule FaithfulWordApi.SearchV13View do
  use FaithfulWordApi, :view
  alias FaithfulWordApi.SearchV13View

  def render("searchv13.json", %{search_v13: search_v13, api_version: api_version}) do
    %{
      result: render_many(search_v13, SearchV13View, "search_v13.json"),
      page_number: search_v13.page_number,
      page_size: search_v13.page_size,
      status: "success",
      total_entries: search_v13.total_entries,
      total_pages: search_v13.total_pages,
      version: api_version
    }

    # %{data: render_many(search_v13, SearchV13View, "search_v13.json")}
  end

  def render("show.json", %{search_v13: search_v13}) do
    %{data: render_one(search_v13, SearchV13View, "search_v13.json")}
  end

  def render("search_v13.json", %{search_v13: search_v13}) do
    %{
      ordinal: search_v13.ordinal,
      uuid: search_v13.uuid,
      track_number: search_v13.track_number,
      medium: search_v13.medium,
      localizedname: search_v13.localizedname,
      multilanguage: search_v13.multilanguage,
      path: search_v13.path,
      content_provider_link: search_v13.content_provider_link,
      ipfs_link: search_v13.ipfs_link,
      language_id: search_v13.language_id,
      presenter_name: search_v13.presenter_name,
      source_material: search_v13.source_material,
      playlist_uuid: search_v13.playlist_uuid,
      tags: search_v13.tags,
      duration: search_v13.duration,
      hash_id: search_v13.hash_id,
      small_thumbnail_path: search_v13.small_thumbnail_path,
      med_thumbnail_path: search_v13.med_thumbnail_path,
      large_thumbnail_path: search_v13.large_thumbnail_path,
      inserted_at: search_v13.inserted_at , #, ## |> render_unix_timestamp(),
      updated_at: search_v13.updated_at , #, ## |> render_unix_timestamp(),
      media_category: search_v13.media_category,
      presented_at: search_v13.presented_at , #, ## |> render_unix_timestamp(),
      published_at: search_v13.published_at# |> render_unix_timestamp()
    }
  end

  defp render_unix_timestamp(nil), do: nil
  defp render_unix_timestamp(datetime), do: DateTime.to_unix(datetime, :second)
end
