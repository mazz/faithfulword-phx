defmodule FaithfulWordApi.ChannelController do
  use FaithfulWordApi, :controller

  alias FaithfulWordApi.ErrorView
  alias FaithfulWordApi.ChannelV13View
  alias FaithfulWordApi.V13

  require Logger
  require Ecto.Query

  action_fallback FaithfulWordApi.FallbackController

  def indexv13(conn, %{"org-id" => orgid, "offset" => offset, "limit" => limit}) do
    Logger.debug("orgid #{inspect %{attributes: orgid}}")
    # IO.inspect(conn)
    #  path_info: ["v1.2", "books"],
    # books =
    # cond do
      # Enum.member?(conn.path_info, "v1.2") ->
      #   V12.books_by_language(lang)
      # Enum.member?(conn.path_info, "v1.3") ->

    #   true ->
    #     nil
    # end
    V13.channels_by_org(orgid, offset, limit)
    |> case do
      nil ->
        put_status(conn, 403)
        |> render(ErrorView, "403.json", %{message: "language not found in supported list."})
      channel_v13 ->
        # Logger.debug("books #{inspect %{attributes: books}}")
        Enum.at(conn.path_info, 0)
        |> case do
          api_version ->
            api_version = String.trim_leading(api_version, "v")
            render(conn, ChannelV13View, "indexv13.json", %{channel_v13: channel_v13, api_version: api_version})
        end
    end
  end
end
