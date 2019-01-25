defmodule FaithfulWordApi.MediaGospelController do
  use FaithfulWordApi, :controller

  alias FaithfulWord.Content
  alias DB.Schema.MediaGospel

  action_fallback FaithfulWordApi.FallbackController

  def index(conn, _params) do
    mediagospel = Content.list_mediagospel()
    render(conn, "index.json", mediagospel: mediagospel)
  end

  def create(conn, %{"media_gospel" => media_gospel_params}) do
    with {:ok, %MediaGospel{} = media_gospel} <- Content.create_media_gospel(media_gospel_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.media_gospel_path(conn, :show, media_gospel))
      |> render("show.json", media_gospel: media_gospel)
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
