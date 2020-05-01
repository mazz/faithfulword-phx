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
