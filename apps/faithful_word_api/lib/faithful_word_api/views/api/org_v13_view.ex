defmodule FaithfulWordApi.OrgV13View do
  use FaithfulWordApi, :view
  alias FaithfulWordApi.OrgV13View

  require Logger

  def render("defaultv13.json", %{org_v13: org_v13, api_version: api_version}) do
    %{
      result: render_many(org_v13, OrgV13View, "org_v13.json"),
      page_number: org_v13.page_number,
      page_size: org_v13.page_size,
      status: "success",
      total_entries: org_v13.total_entries,
      total_pages: org_v13.total_pages,
      version: api_version
    }
  end

  def render("show.json", %{org_v13: org_v13}) do
    %{data: render_one(org_v13, OrgV13View, "org_v13.json")}
  end

  def render("add_org_v13.json", %{add_org_v13: add_org_v13}) do
    # {"Revelation", "Apocalipse", "2c22a08a-80ee-4ec1-be94-f018892fe8ba", "pt"}
    # {b.basename, title.localizedname, b.uuid, title.language_id}
    Logger.debug("org #{inspect(%{attributes: add_org_v13})}")

    %{
      uuid: add_org_v13.uuid,
      basename: add_org_v13.basename,
      shortname: add_org_v13.shortname,
      small_thumbnail_path: add_org_v13.small_thumbnail_path,
      med_thumbnail_path: add_org_v13.med_thumbnail_path,
      large_thumbnail_path: add_org_v13.large_thumbnail_path,
      banner_path: add_org_v13.banner_path,
      hash_id: add_org_v13.hash_id,
      # , ## |> render_unix_timestamp(),
      inserted_at: add_org_v13.inserted_at,
      # |> render_unix_timestamp()
      updated_at: add_org_v13.updated_at
    }
  end

  def render("deletev13.json", %{org_v13: org_v13, api_version: api_version}) do
    Logger.debug("render org_v13 #{inspect(%{attributes: org_v13})}")

    org_map = %{
      # hash_id: task_v10.rubric.hash_id,
      basename: org_v13.basename,
      # languageId: org_v13.language_id,
      uuid: org_v13.uuid,
      small_thumbnail_path: org_v13.small_thumbnail_path,
      med_thumbnail_path: org_v13.med_thumbnail_path,
      large_thumbnail_path: org_v13.large_thumbnail_path,
      banner_path: org_v13.banner_path,
      hash_id: org_v13.hash_id,
      # , ## |> render_unix_timestamp(),
      inserted_at: org_v13.inserted_at,
      # |> render_unix_timestamp()
      updated_at: org_v13.updated_at
    }

    %{result: org_map, status: "success", version: api_version}
  end

  def render("deletev13.json", %{delete_org_v13: delete_org_v13}) do
    %{delete_org_v13: delete_org_v13}
  end

  def render("org_v13.json", %{org_v13: org_v13}) do
    # {"Revelation", "Apocalipse", "2c22a08a-80ee-4ec1-be94-f018892fe8ba", "pt"}
    # {b.basename, title.localizedname, b.uuid, title.language_id}
    Logger.debug("org #{inspect(%{attributes: org_v13})}")

    %{
      basename: org_v13.org.basename,
      uuid: org_v13.org.uuid,
      org_id: org_v13.org.id,
      shortname: org_v13.org.shortname,
      small_thumbnail_path: org_v13.org.small_thumbnail_path,
      med_thumbnail_path: org_v13.org.med_thumbnail_path,
      large_thumbnail_path: org_v13.org.large_thumbnail_path,
      banner_path: org_v13.org.banner_path,
      hash_id: org_v13.org.hash_id,
      channels: org_v13.org.channels,
      # , ## |> render_unix_timestamp(),
      inserted_at: org_v13.org.inserted_at,
      # |> render_unix_timestamp()
      updated_at: org_v13.org.updated_at
    }
  end

  defp render_unix_timestamp(nil), do: nil
  defp render_unix_timestamp(datetime), do: DateTime.to_unix(datetime, :second)
end
