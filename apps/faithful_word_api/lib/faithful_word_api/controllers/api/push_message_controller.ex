defmodule FaithfulWordApi.PushMessageController do
  use FaithfulWordApi, :controller

  alias FaithfulWord.PushNotifications
  alias Db.Schema.PushMessage
  alias FaithfulWordApi.PushMessageV13View
  alias FaithfulWordApi.V13

  require Logger

  action_fallback FaithfulWordApi.FallbackController

  def addv13(conn, %{
    "title" => title,
    "message" => message,
    "org_id" => org_id
  }) do
    V13.add_push_message(
      title,
      message,
      org_id)
    |> case do
      nil ->
        put_status(conn, 403)
        |> put_view(ErrorView)
        |> render("403.json", %{message: "something happened."})

        push_message_v13 ->
        # Logger.debug("channels #{inspect %{attributes: channels}}")
        Logger.debug("push_message_v13 #{inspect(%{attributes: push_message_v13})}")

        Enum.at(conn.path_info, 1)
        |> case do
          api_version ->
            Logger.debug("api_version #{inspect(%{attributes: api_version})}")
            api_version = String.trim_leading(api_version, "v")

            conn
            |> put_view(PushMessageV13View)
            |> render("addv13.json", %{
              push_message_v13: push_message_v13,
              api_version: api_version
            })
        end
    end
  end

  def show(conn, %{"id" => id}) do
    push_message = PushNotifications.get_push_message!(id)
    render(conn, "show.json", push_message: push_message)
  end

  def update(conn, %{"id" => id, "push_message" => push_message_params}) do
    push_message = PushNotifications.get_push_message!(id)

    with {:ok, %PushMessage{} = push_message} <-
           PushNotifications.update_push_message(push_message, push_message_params) do
      render(conn, "show.json", push_message: push_message)
    end
  end

  def delete(conn, %{"id" => id}) do
    push_message = PushNotifications.get_push_message!(id)

    with {:ok, %PushMessage{}} <- PushNotifications.delete_push_message(push_message) do
      send_resp(conn, :no_content, "")
    end
  end
end
