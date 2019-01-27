defmodule FaithfulWordApi.MediaGospelController do
  use FaithfulWordApi, :controller

  alias FaithfulWord.Content
  alias DB.Schema.MediaGospel
  alias FaithfulWordApi.V12
  alias FaithfulWordApi.V13

  alias FaithfulWordApi.ErrorView

  require Logger

  action_fallback FaithfulWordApi.FallbackController

  def index(conn, params = %{"gid" => gid_str, "language-id" => language_id, "offset" => offset, "limit" => limit}) do
    cond do
      Enum.member?(conn.path_info, "v1.2") ->
        V12.gospel_media_by_gid(gid_str, language_id)
      Enum.member?(conn.path_info, "v1.3") ->
        V13.gospel_media_by_gid(gid_str, language_id, offset, limit)
      true ->
        nil
    end
    |>
    case do
      nil ->
        put_status(conn, 403)
        |> render(ErrorView, "403.json", %{message: "language not found in supported list."})
      mediagospel ->
        Logger.debug("mediagospel #{inspect %{attributes: mediagospel}}")
        Enum.at(conn.path_info, 0)
        |> case do
          api_version ->
            render(conn, "index.json", %{mediagospel: mediagospel, api_version: api_version})
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
