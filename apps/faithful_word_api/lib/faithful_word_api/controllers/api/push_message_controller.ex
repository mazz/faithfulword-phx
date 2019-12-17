defmodule FaithfulWordApi.PushMessageController do
  use FaithfulWordApi, :controller

  alias FaithfulWord.PushNotifications
  alias Db.Schema.PushMessage
  alias FaithfulWordApi.PushMessageV13View
  alias FaithfulWordApi.V13

  require Logger

  action_fallback FaithfulWordApi.FallbackController

  plug(
    Guardian.Plug.EnsureAuthenticated,
    [handler: FaithfulWordApi.AuthController]
    when action in [:add_or_update, :send]
  )

  # post "/send", PushMessageController, :sendv13

  def send(conn, %{
        "message_uuid" => message_uuid
      }) do
    V13.send_push_message(message_uuid)
    |> case do
      nil ->
        put_status(conn, 403)
        |> put_view(ErrorView)
        |> render("403.json", %{message: "something happened."})

      push_message_v13 ->
        conn
        |> put_view(PushMessageV13View)
        |> render("addv13.json", %{
          push_message_v13: push_message_v13,
          api_version: "1.3"
        })
    end
  end

  def add_or_update_v13(
        conn,
        params = %{
          "title" => title,
          "message" => message,
          "org_id" => org_id
        }
      ) do
    # conn
    # |> GuardianImpl.Plug.current_resource()
    # optional params
    message_uuid = Map.get(params, "message_uuid", nil)

    V13.add_or_update_push_message(
      title,
      message,
      org_id,
      message_uuid
    )
    |> case do
      {:error, _changeset} ->
        put_status(conn, 403)
        |> put_view(ErrorView)
        |> render("403.json", %{message: "something happened."})

      {:ok, push_message_v13} ->
        # Logger.debug("channels #{inspect %{attributes: channels}}")
        Logger.debug("push_message_v13 #{inspect(%{attributes: push_message_v13})}")

        conn
        |> put_view(PushMessageV13View)
        |> render("addv13.json", %{
          push_message_v13: push_message_v13,
          api_version: "1.3"
        })
    end
  end

  def show(conn, %{"id" => id}) do
    push_message = PushNotifications.get_push_message!(id)
    render(conn, "show.json", push_message: push_message)
  end

  def delete(conn, %{"id" => id}) do
    push_message = PushNotifications.get_push_message!(id)

    with {:ok, %PushMessage{}} <- PushNotifications.delete_push_message(push_message) do
      send_resp(conn, :no_content, "")
    end
  end
end
