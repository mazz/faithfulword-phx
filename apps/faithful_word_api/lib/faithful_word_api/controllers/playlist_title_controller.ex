defmodule FaithfulWordApi.PlaylistTitleController do
  use FaithfulWordApi, :controller

  alias FaithfulWordApi.V13
  alias FaithfulWordApi.ErrorView
  alias FaithfulWordApi.PlaylistTitleV13View

  require Logger

  action_fallback FaithfulWordApi.FallbackController

  plug(
    Guardian.Plug.EnsureAuthenticated,
    [handler: FaithfulWordApi.AuthController]
    when action in [
           # :delete_v13
         ]
  )

  def delete_v13(
        conn,
        %{
          "playlist_title_uuid" => playlist_title_uuid
        }
      ) do
    V13.delete_playlist_title(playlist_title_uuid)
    # |> IO.inspect()
    |> case do
      {:ok, playlist_title} ->
        Logger.debug("playlist_title #{inspect(%{attributes: playlist_title})}")

        conn
        |> put_view(PlaylistTitleV13View)
        |> render("deletev13.json", %{
          playlist_title_v13: playlist_title,
          api_version: "1.3"
        })

      {:error, error} ->
        conn
        |> put_status(error)
        |> put_view(ErrorView)
        |> render("403.json", %{message: "something happened."})
    end
  end
end
