defmodule FaithfulWordApi.GospelController do
  use FaithfulWordApi, :controller

  alias FaithfulWord.Content
  alias DB.Schema.Gospel

  alias FaithfulWordApi.GospelV12View
  alias FaithfulWordApi.GospelV13View
  alias FaithfulWordApi.ErrorView
  alias FaithfulWordApi.V12
  alias FaithfulWordApi.V13

  require Logger

  action_fallback FaithfulWordApi.FallbackController

  def indexv12(conn, %{"language-id" => lang}) do
    Logger.debug("lang #{inspect %{attributes: lang}}")
    V12.gospel_by_language(lang)
    |> case do
      nil ->
        put_status(conn, 403)
        |> put_view(ErrorView)
        |> render("403.json", %{message: "language not found in supported list."})
      gospel_v12 ->
        Logger.debug("gospel_v12 #{inspect %{attributes: gospel_v12}}")
        conn
        |> put_view(GospelV12View)
        |> render("indexv12.json", %{gospel_v12: gospel_v12})
    end
  end

  def indexv13(conn, %{"language-id" => lang}) do
    Logger.debug("lang #{inspect %{attributes: lang}}")
    V13.gospel_by_language(lang)
    |>
    case do
      nil ->
        put_status(conn, 403)
        |> put_view(ErrorView)
        |> render("403.json", %{message: "language not found in supported list."})
      gospel_v13 ->
        Logger.debug("gospel_v13 #{inspect %{attributes: gospel_v13}}")
        Enum.at(conn.path_info, 0)
        |>
        case do
          api_version ->
            api_version = String.trim_leading(api_version, "v")
            conn
            |> put_view(GospelV13View)
            |> render("indexv13.json", %{gospel_v13: gospel_v13, api_version: api_version})
        end
    end
  end

end
