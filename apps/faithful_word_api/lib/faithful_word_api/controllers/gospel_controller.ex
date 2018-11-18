defmodule FaithfulWordApi.GospelController do
  use FaithfulWordApi, :controller

  alias FaithfulWord.Content
  alias FaithfulWord.Content.Gospel

  action_fallback FaithfulWordApi.FallbackController

  def index(conn, _params) do
    gospel = Content.list_gospel()
    render(conn, "index.json", gospel: gospel)
  end

  def create(conn, %{"gospel" => gospel_params}) do
    with {:ok, %Gospel{} = gospel} <- Content.create_gospel(gospel_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.gospel_path(conn, :show, gospel))
      |> render("show.json", gospel: gospel)
    end
  end

  def show(conn, %{"id" => id}) do
    gospel = Content.get_gospel!(id)
    render(conn, "show.json", gospel: gospel)
  end

  def update(conn, %{"id" => id, "gospel" => gospel_params}) do
    gospel = Content.get_gospel!(id)

    with {:ok, %Gospel{} = gospel} <- Content.update_gospel(gospel, gospel_params) do
      render(conn, "show.json", gospel: gospel)
    end
  end

  def delete(conn, %{"id" => id}) do
    gospel = Content.get_gospel!(id)

    with {:ok, %Gospel{}} <- Content.delete_gospel(gospel) do
      send_resp(conn, :no_content, "")
    end
  end
end
