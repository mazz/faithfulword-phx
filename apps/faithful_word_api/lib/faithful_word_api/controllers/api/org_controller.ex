defmodule FaithfulWordApi.OrgController do
  use FaithfulWordApi, :controller

  alias FaithfulWordApi.ErrorView
  alias FaithfulWordApi.OrgV13View
  alias FaithfulWordApi.ChannelV13View
  alias FaithfulWordApi.V13

  require Logger
  require Ecto.Query

  action_fallback FaithfulWordApi.FallbackController

  def defaultv13(conn, params = %{"offset" => offset, "limit" => limit}) do
    # optional params
    updated_after = Map.get(params, "upd-after", nil)

    # Logger.debug("orgid #{inspect %{attributes: orgid}}")
    V13.orgs_default_org(offset, limit, updated_after)
    |> case do
      nil ->
        put_status(conn, 403)
        |> put_view(ErrorView)
        |> render("403.json", %{message: "language not found in supported list."})

      org_v13 ->
        # Logger.debug("books #{inspect %{attributes: books}}")
        Enum.at(conn.path_info, 1)
        |> case do
          api_version ->
            api_version = String.trim_leading(api_version, "v")

            conn
            |> put_view(OrgV13View)
            |> render("defaultv13.json", %{org_v13: org_v13, api_version: api_version})
        end
    end
  end

  def add_or_update_v13(
        conn,
        params = %{
          "basename" => basename,
          "shortname" => shortname
        }
      ) do
    # optional params
    small_thumbnail_path = Map.get(params, "small_thumbnail_path", nil)
    med_thumbnail_path = Map.get(params, "med_thumbnail_path", nil)
    large_thumbnail_path = Map.get(params, "large_thumbnail_path", nil)
    banner_path = Map.get(params, "banner_path", nil)
    org_uuid = Map.get(params, "org_uuid", nil)

    V13.add_or_update_org(
      basename,
      shortname,
      small_thumbnail_path,
      med_thumbnail_path,
      large_thumbnail_path,
      banner_path,
      org_uuid
    )
    # |> IO.inspect()
    |> case do
      {:ok, org} ->
        Logger.debug("org #{inspect(%{attributes: org})}")

        conn
        |> put_view(OrgV13View)
        |> render("add_org_v13.json", %{
          add_org_v13: org,
          api_version: "1.3"
        })

      {:error, _changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(ErrorView)
        |> render("403.json", %{message: "something happened."})
    end
  end

  def channelsv13(conn, params = %{"uuid" => orguuid, "offset" => offset, "limit" => limit}) do
    Logger.debug("orguuid #{inspect(%{attributes: orguuid})}")
    # optional params
    updated_after = Map.get(params, "upd-after", nil)

    V13.channels_by_org_uuid(orguuid, offset, limit, updated_after)
    |> case do
      nil ->
        put_status(conn, 403)
        |> put_view(ErrorView)
        |> render("403.json", %{message: "language not found in supported list."})

      channel_v13 ->
        Enum.at(conn.path_info, 1)
        |> case do
          api_version ->
            api_version = String.trim_leading(api_version, "v")

            conn
            |> put_view(ChannelV13View)
            |> render("channelsv13.json", %{channel_v13: channel_v13, api_version: api_version})
        end
    end
  end
end
