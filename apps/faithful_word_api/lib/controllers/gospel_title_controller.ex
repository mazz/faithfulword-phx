defmodule FaithfulWordApi.GospelTitleController do
  use FaithfulWordApi, :controller

  alias FaithfulWord.Content
  alias DB.Schema.GospelTitle

  action_fallback FaithfulWordApi.FallbackController

  def index(conn, _params) do
    gospeltitle = Content.list_gospeltitle()
    render(conn, "index.json", gospeltitle: gospeltitle)
  end

  def create(conn, %{"gospel_title" => gospel_title_params}) do
    with {:ok, %GospelTitle{} = gospel_title} <- Content.create_gospel_title(gospel_title_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.gospel_title_path(conn, :show, gospel_title))
      |> render("show.json", gospel_title: gospel_title)
    end
  end

  def show(conn, %{"id" => id}) do
    gospel_title = Content.get_gospel_title!(id)
    render(conn, "show.json", gospel_title: gospel_title)
  end

  def update(conn, %{"id" => id, "gospel_title" => gospel_title_params}) do
    gospel_title = Content.get_gospel_title!(id)

    with {:ok, %GospelTitle{} = gospel_title} <- Content.update_gospel_title(gospel_title, gospel_title_params) do
      render(conn, "show.json", gospel_title: gospel_title)
    end
  end

  def delete(conn, %{"id" => id}) do
    gospel_title = Content.get_gospel_title!(id)

    with {:ok, %GospelTitle{}} <- Content.delete_gospel_title(gospel_title) do
      send_resp(conn, :no_content, "")
    end
  end
end
