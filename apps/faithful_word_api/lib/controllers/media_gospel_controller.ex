defmodule FaithfulWordApi.MediaGospelController do
  use FaithfulWordApi, :controller

  alias FaithfulWord.Content
  alias DB.Schema.MediaGospel
  alias FaithfulWordApi.V12
  alias FaithfulWordApi.V13

  alias FaithfulWordApi.ErrorView
  alias FaithfulWordApi.MediaGospelV12View
  alias FaithfulWordApi.MediaGospelView

  require Logger

  action_fallback FaithfulWordApi.FallbackController

  def indexv12(conn, params = %{"gid" => gid_str}) do
    V12.gospel_media_by_gid(gid_str)
    |>
    case do
      nil ->
        put_status(conn, 403)
        |> render(ErrorView, "403.json", %{message: "language not found in supported list."})
      media_gospel_v12 ->
        Logger.debug("media_gospel_v12 #{inspect %{attributes: media_gospel_v12}}")
        render(conn, MediaGospelV12View, "indexv12.json", %{media_gospel_v12: media_gospel_v12})

        # Enum.at(conn.path_info, 0)
        # |> case do
          # api_version ->
            # render(conn, "index.json", %{media_gospel: media_gospel})
            # render(conn, BookTitleView, "index.json", %{booktitle: booktitle, api_version: api_version})
            # render(conn, UserView, "user_with_token.json", %{user: user, token: token})
        # end
      end
  end

  def index(conn, params = %{"uuid" => gid_str, "offset" => offset, "limit" => limit}) do
    V13.gospel_media_by_uuid(gid_str, offset, limit)
    |>
    case do
      nil ->
        put_status(conn, 403)
        |> render(ErrorView, "403.json", %{message: "language not found in supported list."})
      media_gospel ->
        Logger.debug("media_gospel #{inspect %{attributes: media_gospel}}")
        Enum.at(conn.path_info, 0)
        |> case do
          api_version ->
            render(conn, MediaGospelView, "index.json", %{media_gospel: media_gospel, api_version: api_version})
            # render(conn, BookTitleView, "index.json", %{booktitle: booktitle, api_version: api_version})
            # render(conn, UserView, "user_with_token.json", %{user: user, token: token})
        end
      end
  end

  def show(conn, %{"id" => id}) do
    media_gospel = Content.get_media_gospel!(id)
    render(conn, "show.json", media_gospel: media_gospel)
  end

  def update(conn, %{"id" => id, "media_gospel" => media_gospel_params}) do
    media_gospel = Content.get_media_gospel!(id)

    with {:ok, %MediaGospel{} = media_gospel} <- Content.update_media_gospel(media_gospel, media_gospel_params) do
      render(conn, "show.json", media_gospel: media_gospel)
    end
  end

  def delete(conn, %{"id" => id}) do
    media_gospel = Content.get_media_gospel!(id)

    with {:ok, %MediaGospel{}} <- Content.delete_media_gospel(media_gospel) do
      send_resp(conn, :no_content, "")
    end
  end
end
