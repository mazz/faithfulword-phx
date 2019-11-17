defmodule FaithfulWordApi.PushMessageV13View do
  use FaithfulWordApi, :view
  alias FaithfulWordApi.PushMessageV13View

  require Logger

  def render("addv13.json", %{push_message_v13: push_message_v13, api_version: api_version}) do
    Logger.debug("render push_message_v13 #{inspect(%{attributes: push_message_v13})}")
    %{result: push_message_v13, status: "success", version: api_version}
  end

  def render("addv13.json", %{add_push_message_v13: add_push_message_v13}) do
    %{add_push_message_v13: add_push_message_v13}
  end

  def render("channelsv13.json", %{push_message_v13: push_message_v13, api_version: api_version}) do
    %{
      result: render_many(push_message_v13, PushMessageV13View, "push_message_v13.json"),
      pageNumber: push_message_v13.page_number,
      pageSize: push_message_v13.page_size,
      status: "success",
      totalEntries: push_message_v13.total_entries,
      totalPages: push_message_v13.total_pages,
      version: api_version
    }
  end

  def render("show.json", %{push_message_v13: push_message_v13}) do
    %{data: render_one(push_message_v13, PushMessageV13View, "push_message_v13.json")}
  end

  def render("push_message_v13.json", %{push_message_v13: push_message_v13}) do
    Logger.debug("channel #{inspect(%{attributes: push_message_v13})}")

    %{
      title: push_message_v13.basename,
      message: push_message_v13.uuid,
      org_id: push_message_v13.org_id,
      insertedAt: push_message_v13.inserted_at,  , #, ## |> render_unix_timestamp(),
      updatedAt: push_message_v13.updated_at # |> render_unix_timestamp()
    }
  end

  defp render_unix_timestamp(nil), do: nil
  defp render_unix_timestamp(datetime), do: DateTime.to_unix(datetime, :second)
end
