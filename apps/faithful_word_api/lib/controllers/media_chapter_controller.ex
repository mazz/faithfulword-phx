defmodule FaithfulWordApi.MediaChapterController do
  use FaithfulWordApi, :controller

  alias FaithfulWord.Content
  alias DB.Schema.MediaChapter
  alias FaithfulWordApi.V12

  alias FaithfulWordApi.ErrorView

  action_fallback FaithfulWordApi.FallbackController

  def index(conn, params = %{"bid" => bid_str, "language-id" => language_id}) do
    cond do
      Enum.member?(conn.path_info, "v1.2") ->
        V12.chapter_media_by_bid(bid_str, language_id)
      true ->
        nil
    end
    # |>
    # case do
    #   nil ->
        put_status(conn, 403)
        |> render(ErrorView, "403.json", %{message: "language not found in supported list."})
      # media ->
      #   Logger.debug("media #{inspect %{attributes: media}}")
      #   Enum.at(conn.path_info, 0)
      #   |> case do
      #     api_version ->
      #       # render(conn, BookTitleView, "index.json", %{booktitle: booktitle, api_version: api_version})
      #       # render(conn, UserView, "user_with_token.json", %{user: user, token: token})
      #   end
      # end
  end





    # mediachapter = Content.list_mediachapter()
    # render(conn, "index.json", mediachapter: mediachapter)


    # v1.3
    # def media(conn, params = %{"uuid" => uuid_str}) do
    #   cond do
    #     Enum.member?(conn.path_info, "v1.3") ->
    #       V13.chapter_media_by_uuid(uuid_str)
    #     true ->
    #       nil
    #   end
    # end

    # def media(conn, params = %{"bid" => bid_str, "language-id" => language_id}) do
    #   cond do
    #     Enum.member?(conn.path_info, "v1.2") ->
    #       V12.chapter_media_by_bid(bid_str, language_id)
    #     true ->
    #       nil
    #   end |> case do
    #     nil ->
    #       put_status(conn, 403)
    #       |> render(ErrorView, "403.json", %{message: "language not found in supported list."})
    #     media ->
    #       Logger.debug("media #{inspect %{attributes: media}}")
    #       Enum.at(conn.path_info, 0)
    #       |> case do
    #         api_version ->
    #           render(conn, BookTitleView, "index.json", %{booktitle: booktitle, api_version: api_version})
    #           # render(conn, UserView, "user_with_token.json", %{user: user, token: token})
    #       end
    #   end


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
