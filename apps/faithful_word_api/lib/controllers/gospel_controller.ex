defmodule FaithfulWordApi.GospelController do
  use FaithfulWordApi, :controller

  alias FaithfulWord.Content
  alias DB.Schema.Gospel

  alias FaithfulWordApi.GospelV12View
  alias FaithfulWordApi.GospelView
  alias FaithfulWordApi.ErrorView
  alias FaithfulWordApi.V12
  alias FaithfulWordApi.V13

  require Logger

  action_fallback FaithfulWordApi.FallbackController

  def indexv12(conn, %{"language-id" => lang}) do
    Logger.debug("lang #{inspect %{attributes: lang}}")
    IO.inspect(conn)
    #  path_info: ["v1.2", "books"],
    # books =
    # cond do
      # Enum.member?(conn.path_info, "v1.2") ->

      # Enum.member?(conn.path_info, "v1.3") ->
        # V13.gospel_by_language(lang)
      # true ->
        # nil
    # end
    V12.gospel_by_language(lang)
    |> case do
      nil ->
        put_status(conn, 403)
        |> render(ErrorView, "403.json", %{message: "language not found in supported list."})
      gospel ->
        Logger.debug("gospel #{inspect %{attributes: gospel}}")
        render(conn, GospelV12View, "indexv12.json", %{gospel: gospel})
        # Enum.at(conn.path_info, 0)
        # |> case do
          # api_version ->
            # cond do
              # api_version == "v1.2" ->
                # render(conn, UserView, "user_with_token.json", %{user: user, token: token})

              # api_version != "v1.2" ->
                # render(conn, GospelView, "index.json", %{gospel: gospel, api_version: api_version})
              # true ->
                # nil
            # end
            # render(conn, "index.json", %{gospel: gospel, api_version: api_version})
        # end
    end
  end

  def index(conn, %{"language-id" => lang}) do
    Logger.debug("lang #{inspect %{attributes: lang}}")
    IO.inspect(conn)
    #  path_info: ["v1.2", "books"],
    # books =
    # cond do
      # Enum.member?(conn.path_info, "v1.2") ->
        # V12.gospel_by_language(lang)
      # Enum.member?(conn.path_info, "v1.3") ->
      # true ->
        # nil
    # end
    V13.gospel_by_language(lang)
    |>
    case do
      nil ->
        put_status(conn, 403)
        |> render(ErrorView, "403.json", %{message: "language not found in supported list."})
      gospel ->
        Logger.debug("gospel #{inspect %{attributes: gospel}}")
        # Enum.at(conn.path_info, 0)
        render(conn, GospelView, "index.json", %{gospel: gospel})
        # case do
          # api_version ->
            # cond do
              # api_version == "v1.2" ->
                # render(conn, UserView, "user_with_token.json", %{user: user, token: token})
                # render(conn, GospelV12View, "index.json", %{gospel: gospel})
              # api_version != "v1.2" ->

              # true ->
                # nil
            # end
            # render(conn, "index.json", %{gospel: gospel, api_version: api_version})
        # end
    end
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
