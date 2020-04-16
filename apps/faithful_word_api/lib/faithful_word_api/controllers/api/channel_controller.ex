defmodule FaithfulWordApi.ChannelController do
  use FaithfulWordApi, :controller

  alias FaithfulWordApi.ErrorView
  alias FaithfulWordApi.ChannelV13View
  alias FaithfulWordApi.V13

  require Logger
  require Ecto.Query

  action_fallback FaithfulWordApi.FallbackController

  plug(
    Guardian.Plug.EnsureAuthenticated,
    [handler: FaithfulWordApi.AuthController]
    when action in [
           # :addv13
         ]
  )

  def add_or_update_v13(
        conn,
        params = %{
          "ordinal" => ordinal,
          "basename" => basename,
          "org_id" => org_id
        }
      ) do
    # optional params
    channel_uuid = Map.get(params, "channel_uuid", nil)
    small_thumbnail_path = Map.get(params, "small_thumbnail_path", nil)
    med_thumbnail_path = Map.get(params, "med_thumbnail_path", nil)
    large_thumbnail_path = Map.get(params, "large_thumbnail_path", nil)
    banner_path = Map.get(params, "banner_path", nil)

    V13.add_or_update_channel(
      ordinal,
      basename,
      small_thumbnail_path,
      med_thumbnail_path,
      large_thumbnail_path,
      banner_path,
      org_id,
      channel_uuid
    )

    # |> case do
    #   {:ok, playlist} ->
    #     Logger.debug("playlist #{inspect(%{attributes: playlist})}")

    #     conn
    #     |> put_view(PlaylistV13View)
    #     |> render("addv13.json", %{
    #       playlist_v13: playlist,
    #       api_version: "1.3"
    #     })

    #   {:error, _changeset} ->
    #     conn
    #     |> put_status(:unprocessable_entity)
    #     |> put_view(ErrorView)
    #     |> render("403.json", %{message: "something happened."})
    # end

    |> case do
      {:error, _changeset} ->
        put_status(conn, 403)
        |> put_view(ErrorView)
        |> render("403.json", %{message: "something happened."})

      {:ok, channel_v13} ->
        # Logger.debug("channels #{inspect %{attributes: channels}}")
        Logger.debug("channel_v13 #{inspect(%{attributes: channel_v13})}")

        # Enum.at(conn.path_info, 1)
        # |> case do
        #   api_version ->
        #     Logger.debug("api_version #{inspect(%{attributes: api_version})}")
        #     api_version = String.trim_leading(api_version, "v")

        conn
        |> put_view(ChannelV13View)
        |> render("addv13.json", %{
          channel_v13: channel_v13,
          api_version: "1.3"
        })

        # end
    end
  end
end
