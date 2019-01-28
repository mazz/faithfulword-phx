defmodule FaithfulWordApi.MusicController do
  use FaithfulWordApi, :controller

  alias FaithfulWord.Content
  alias DB.Schema.Music
  alias FaithfulWordApi.MusicView
  alias FaithfulWordApi.MusicV12View
  alias FaithfulWordApi.V12
  alias FaithfulWordApi.V13

  require Logger

  action_fallback FaithfulWordApi.FallbackController

  def indexv12(conn, _params) do
    V12.music()
    |> case do
      nil ->
        put_status(conn, 403)
        |> render(ErrorView, "403.json", %{message: "language not found in supported list."})
      music_v12 ->
        Logger.debug("music_v12 #{inspect %{attributes: music_v12}}")
        render(conn, MusicV12View, "indexv12.json", %{music_v12: music_v12})
    end
  end

  # def index(conn, %{"language-id" => lang}) do
  def index(conn,  %{"language-id" => lang, "offset" => offset, "limit" => limit}) do
      Logger.debug("lang #{inspect %{attributes: lang}}")
    IO.inspect(conn)
    V13.music_by_language(lang, offset, limit)
    |>
    case do
      nil ->
        put_status(conn, 403)
        |> render(ErrorView, "403.json", %{message: "language not found in supported list."})
      music ->
        # render(conn, GospelView, "index.json", %{music: music})

        Logger.debug("music #{inspect %{attributes: music}}")
        Enum.at(conn.path_info, 0)
        |>
        case do
          api_version ->
                render(conn, "index.json", %{music: music, api_version: api_version})
        end
    end
  end

  def create(conn, %{"music" => music_params}) do
    with {:ok, %Music{} = music} <- Content.create_music(music_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.music_path(conn, :show, music))
      |> render("show.json", music: music)
    end
  end

  def show(conn, %{"id" => id}) do
    music = Content.get_music!(id)
    render(conn, "show.json", music: music)
  end

  def update(conn, %{"id" => id, "music" => music_params}) do
    music = Content.get_music!(id)

    with {:ok, %Music{} = music} <- Content.update_music(music, music_params) do
      render(conn, "show.json", music: music)
    end
  end

  def delete(conn, %{"id" => id}) do
    music = Content.get_music!(id)

    with {:ok, %Music{}} <- Content.delete_music(music) do
      send_resp(conn, :no_content, "")
    end
  end
end
