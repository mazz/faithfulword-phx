defmodule FaithfulWordApi.PlaylistTitleV13View do
  use FaithfulWordApi, :view
  alias FaithfulWordApi.PlaylistTitleV13View

  require Logger

  def render("addv13.json", %{playlist_title_v13: playlist_title_v13, api_version: api_version}) do
    Logger.debug("render playlist_title_v13 #{inspect(%{attributes: playlist_title_v13})}")

    playlist_title_map = %{
      # hash_id: task_v10.rubric.hash_id,
      basename: playlist_title_v13.basename,
      # languageId: playlist_title_v13.language_id,
      uuid: playlist_title_v13.uuid,
      channel_id: playlist_title_v13.channel_id,
      ordinal: playlist_title_v13.ordinal,
      small_thumbnail_path: playlist_title_v13.small_thumbnail_path,
      med_thumbnail_path: playlist_title_v13.med_thumbnail_path,
      large_thumbnail_path: playlist_title_v13.large_thumbnail_path,
      banner_path: playlist_title_v13.banner_path,
      media_category: playlist_title_v13.media_category,
      hash_id: playlist_title_v13.hash_id,
      # , ## |> render_unix_timestamp(),
      inserted_at: playlist_title_v13.inserted_at,
      # |> render_unix_timestamp()
      updated_at: playlist_title_v13.updated_at
    }

    %{result: playlist_title_map, status: "success", version: api_version}
  end

  def render("addv13.json", %{add_playlist_title_v13: add_playlist_title_v13}) do
    %{add_playlist_title_v13: add_playlist_title_v13}
  end

  def render("deletev13.json", %{playlist_title_v13: playlist_title_v13, api_version: api_version}) do
    Logger.debug("render playlist_title_v13 #{inspect(%{attributes: playlist_title_v13})}")

    playlist_title_map = %{
      # hash_id: task_v10.rubric.hash_id,
      language_id: playlist_title_v13.language_id,
      localizedname: playlist_title_v13.localizedname,
      uuid: playlist_title_v13.uuid,
      playlist_id: playlist_title_v13.playlist_id
    }

    %{result: playlist_title_map, status: "success", version: api_version}
  end

  def render("deletev13.json", %{delete_playlist_title_v13: delete_playlist_title_v13}) do
    %{delete_playlist_title_v13: delete_playlist_title_v13}
  end

  def render("indexv13.json", %{playlist_title_v13: playlist_title_v13, api_version: api_version}) do
    %{
      result: render_many(playlist_title_v13, PlaylistTitleV13View, "playlist_title_v13.json"),
      page_number: playlist_title_v13.page_number,
      page_size: playlist_title_v13.page_size,
      status: "success",
      total_entries: playlist_title_v13.total_entries,
      total_pages: playlist_title_v13.total_pages,
      version: api_version
    }

    # %{data: render_many(playlist_title_v13, PlaylistTitleV13View, "playlist_title_v13.json")}
  end

  def render("show.json", %{playlist_title_v13: playlist_title_v13}) do
    %{data: render_one(playlist_title_v13, PlaylistTitleV13View, "playlist_title_v13.json")}
  end

  def render("playlist_title_v13.json", %{playlist_title_v13: playlist_title_v13}) do
    %{
      language_id: playlist_title_v13.language_id,
      localizedname: playlist_title_v13.localizedname,
      uuid: playlist_title_v13.uuid,
      playlist_id: playlist_title_v13.playlist_id
    }
  end

  defp render_unix_timestamp(nil), do: nil
  defp render_unix_timestamp(datetime), do: DateTime.to_unix(datetime, :second)
end
