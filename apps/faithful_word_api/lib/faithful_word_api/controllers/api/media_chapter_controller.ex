defmodule FaithfulWordApi.MediaChapterController do
  use FaithfulWordApi, :controller

  alias FaithfulWord.Content
  alias DB.Schema.MediaChapter
  alias FaithfulWordApi.V12
  alias FaithfulWordApi.V13

  alias FaithfulWordApi.ErrorView
  alias FaithfulWordApi.MediaChapterV12View
  alias FaithfulWordApi.MediaChapterV13View

  require Logger

  action_fallback FaithfulWordApi.FallbackController

  def indexv12(conn, params = %{"bid" => bid_str, "language-id" => language_id}) do
    V12.chapter_media_by_bid(bid_str, language_id)
    |>
    case do
      nil ->
        put_status(conn, 403)
        |> render(ErrorView, "403.json", %{message: "language not found in supported list."})
      media_chapter_v12 ->
        Logger.debug("media_chapter_v12 #{inspect %{attributes: media_chapter_v12}}")
        render(conn, MediaChapterV12View, "indexv12.json", %{media_chapter_v12: media_chapter_v12})

        # Enum.at(conn.path_info, 0)
        # |> case do
          # api_version ->
            # render(conn, "index.json", %{mediachapter: mediachapter})

            # render(conn, BookTitleView, "index.json", %{booktitle: booktitle, api_version: api_version})
            # render(conn, UserView, "user_with_token.json", %{user: user, token: token})
        # end
      end
  end

  def indexv13(conn, params = %{"uuid" => bid_str, "language-id" => language_id, "offset" => offset, "limit" => limit}) do
    V13.chapter_media_by_uuid(bid_str, language_id, offset, limit)
    |>
    case do
      nil ->
        put_status(conn, 403)
        |> render(ErrorView, "403.json", %{message: "language not found in supported list."})
      media_chapter_v13 ->
        Logger.debug("media_chapter_v13 #{inspect %{attributes: media_chapter_v13}}")
        Enum.at(conn.path_info, 0)
        |> case do
          api_version ->
            api_version = String.trim_leading(api_version, "v")
            render(conn, MediaChapterV13View, "indexv13.json", %{media_chapter_v13: media_chapter_v13, api_version: api_version})
            # render(conn, BookTitleView, "index.json", %{booktitle: booktitle, api_version: api_version})
            # render(conn, UserView, "user_with_token.json", %{user: user, token: token})
        end
      end
  end


  def create(conn, %{"media_chapter" => media_chapter_params}) do
    with {:ok, %MediaChapter{} = media_chapter} <- Content.create_media_chapter(media_chapter_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.media_chapter_path(conn, :show, media_chapter))
      |> render("show.json", media_chapter: media_chapter)
    end
  end

  def show(conn, %{"id" => id}) do
    media_chapter = Content.get_media_chapter!(id)
    render(conn, "show.json", media_chapter: media_chapter)
  end

  def update(conn, %{"id" => id, "media_chapter" => media_chapter_params}) do
    media_chapter = Content.get_media_chapter!(id)

    with {:ok, %MediaChapter{} = media_chapter} <- Content.update_media_chapter(media_chapter, media_chapter_params) do
      render(conn, "show.json", media_chapter: media_chapter)
    end
  end

  def delete(conn, %{"id" => id}) do
    media_chapter = Content.get_media_chapter!(id)

    with {:ok, %MediaChapter{}} <- Content.delete_media_chapter(media_chapter) do
      send_resp(conn, :no_content, "")
    end
  end
end
