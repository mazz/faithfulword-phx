defmodule FaithfulWordApi.ChannelController do
  use FaithfulWordApi, :controller

  alias FaithfulWordApi.ErrorView
  alias FaithfulWordApi.ChannelV13View
  alias FaithfulWordApi.V13

  require Logger
  require Ecto.Query

  action_fallback FaithfulWordApi.FallbackController

  def addv13(conn, %{
    "ordinal" => ordinal,
    "basename" => basename,
    "small_thumbnail_path" => small_thumbnail_path,
    "med_thumbnail_path" => med_thumbnail_path,
    "large_thumbnail_path" => large_thumbnail_path,
    "banner_path" => banner_path,
    "org_id" => org_id
  }) do
    V13.add_channel(
      ordinal,
      basename,
      small_thumbnail_path,
      med_thumbnail_path,
      large_thumbnail_path,
      banner_path,
      org_id)
    |> case do
      nil ->
        put_status(conn, 403)
        |> put_view(ErrorView)
        |> render("403.json", %{message: "something happened."})

        channel_v13 ->
        # Logger.debug("channels #{inspect %{attributes: channels}}")
        Logger.debug("channel_v13 #{inspect(%{attributes: channel_v13})}")

        Enum.at(conn.path_info, 1)
        |> case do
          api_version ->
            Logger.debug("api_version #{inspect(%{attributes: api_version})}")
            api_version = String.trim_leading(api_version, "v")

            conn
            |> put_view(ChannelV13View)
            |> render("addv13.json", %{
              channel_v13: channel_v13,
              api_version: api_version
            })
        end
    end
  end

  def indexv13(conn, %{"org-uuid" => orguuid, "offset" => offset, "limit" => limit}) do
    Logger.debug("orguuid #{inspect(%{attributes: orguuid})}")

    V13.channels_by_org_uuid(orguuid, offset, limit)
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
            |> render("indexv13.json", %{channel_v13: channel_v13, api_version: api_version})
        end
    end
  end
end
