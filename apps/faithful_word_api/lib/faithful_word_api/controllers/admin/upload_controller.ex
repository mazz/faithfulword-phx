defmodule FaithfulWordApi.Admin.UploadController do
  use FaithfulWordApi, :controller
  # alias Phoenix.LiveView
  # alias FaithfulWordApi.Admin.UploadView

  action_fallback FaithfulWordApi.FallbackController

  def index(conn, _params) do
    # LiveView.Controller.live_render(conn, FaithfulWordApi.Admin.UploadView, session: %{})
    # pushmessage = PushNotifications.list_pushmessage()
    render(conn, "upload.html")
  end

  # def create(conn, %{"push_message" => push_message_params}) do
  #   with {:ok, %PushMessage{} = push_message} <- PushNotifications.create_push_message(push_message_params) do
  #     conn
  #     |> put_status(:created)
  #     |> put_resp_header("location", Routes.push_message_path(conn, :show, push_message))
  #     |> render("show.json", push_message: push_message)
  #   end
  # end

  # def show(conn, %{"id" => id}) do
  #   push_message = PushNotifications.get_push_message!(id)
  #   render(conn, "show.json", push_message: push_message)
  # end

end
