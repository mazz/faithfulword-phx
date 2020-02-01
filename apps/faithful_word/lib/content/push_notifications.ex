defmodule FaithfulWord.PushNotifications do
  @moduledoc """
  The PushNotifications context.
  """
  import Ecto.Query, warn: false
  alias Db.Repo
  alias Db.Schema.{PushMessage, ClientDevice, MediaItem}

  require Logger

  def send_pushmessage_now(message) do
    # push to all_devices
    # TODO: only push to devices for an org_id

    fw_hostname = System.get_env("FW_HOSTNAME")
    Logger.debug("fw_hostname #{inspect(%{attributes: fw_hostname})}")


    Repo.all(ClientDevice)
      |> Enum.map(fn(device) -> device.firebase_token end)
      |> Pigeon.FCM.Notification.new()
      |> Pigeon.FCM.Notification.put_notification(%{
        "title" => message.title,
        "body" => message.message
      })
      |> Pigeon.FCM.Notification.put_data(%{
        "push_message_uuid" => message.uuid,
        "deep_link_route" => "/fwbcapp/push_message/#{message.uuid}",
        "short_url" => "https://#{fw_hostname}/push_message_hashid",
        "media_type" => "push_message",
        "image_thumbnail_path" => "thumbs/lg/0005-0026-Psalm81-en.jpg",
        "image_thumbnail_url" => "https://i.ytimg.com/vi/zPNyuv3fw_4/hqdefault.jpg",
        "mutable-content" => true,
        "version" => "1.3"
      })
      |> Pigeon.FCM.Notification.put_mutable_content(true)
      |> Pigeon.FCM.push(on_response: &handle_push/1)
  end

  def send_pushmessage_now(message, media_item_uuid) do
    case Repo.get_by(MediaItem, uuid: media_item_uuid) do
      # add media_item
      nil ->
        Logger.debug("could not find media item with uuid: #{inspect(%{attributes: media_item_uuid})}")

      media_item ->
        Logger.debug("found media item with uuid: #{inspect(%{attributes: media_item_uuid})}")

        # push to all_devices
        # TODO: only push to devices for an org_id

        fw_hostname = System.get_env("FW_HOSTNAME")
        Logger.debug("fw_hostname #{inspect(%{attributes: fw_hostname})}")

        Repo.all(ClientDevice)
          |> Enum.map(fn(device) -> device.firebase_token end)
          |> Pigeon.FCM.Notification.new()
          |> Pigeon.FCM.Notification.put_notification(%{
            "title" => message.title,
            "body" => message.message
          })
          |> Pigeon.FCM.Notification.put_data(%{
            "push_message_uuid" => message.uuid,
            "deep_link_route" => "/fwbcapp/media_item/#{media_item.uuid}",
            "short_url" => "https://#{fw_hostname}/m/#{media_item.hash_id}",
            "hash_id" => media_item.hash_id,
            "media_type" => "media_item",
            "media_uuid" => media_item.uuid,
            "image_thumbnail_path" => media_item.large_thumbnail_path,
            "image_thumbnail_url" => "https://i.ytimg.com/vi/zPNyuv3fw_4/hqdefault.jpg",
            "mutable-content" => true,
            "version" => "1.3"
          })
          |> Pigeon.FCM.Notification.put_mutable_content(true)
          |> Pigeon.FCM.push(on_response: &handle_push/1)
    end
  end

  def handle_push(%Pigeon.FCM.Notification{status: :success} = notif) do
    to_update = Pigeon.FCM.Notification.update?(notif)
    Logger.debug("handle_push to_update #{inspect(%{attributes: to_update})}")

    to_remove = Pigeon.FCM.Notification.remove?(notif)
    Logger.debug("handle_push to_remove #{inspect(%{attributes: to_remove})}")

    # do the reg ID update and deletes
  end

  def handle_push(%Pigeon.FCM.Notification{status: other_error}) do
    # some other error happened
    Logger.debug("handle_push other_error #{inspect(%{attributes: other_error})}")
  end

  @doc """
  Returns the list of pushmessage.

  ## Examples

      iex> list_pushmessage()
      [%PushMessage{}, ...]

  """
  def list_pushmessage do
    Repo.all(PushMessage)
  end

  @doc """
  Gets a single push_message.

  Raises `Ecto.NoResultsError` if the Push message does not exist.

  ## Examples

      iex> get_push_message!(123)
      %PushMessage{}

      iex> get_push_message!(456)
      ** (Ecto.NoResultsError)

  """
  def get_push_message!(id), do: Repo.get!(PushMessage, id)

  @doc """
  Creates a push_message.

  ## Examples

      iex> create_push_message(%{field: value})
      {:ok, %PushMessage{}}

      iex> create_push_message(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_push_message(attrs \\ %{}) do
    %PushMessage{}
    |> PushMessage.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a push_message.

  ## Examples

      iex> update_push_message(push_message, %{field: new_value})
      {:ok, %PushMessage{}}

      iex> update_push_message(push_message, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_push_message(%PushMessage{} = push_message, attrs) do
    push_message
    |> PushMessage.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a PushMessage.

  ## Examples

      iex> delete_push_message(push_message)
      {:ok, %PushMessage{}}

      iex> delete_push_message(push_message)
      {:error, %Ecto.Changeset{}}

  """
  def delete_push_message(%PushMessage{} = push_message) do
    Repo.delete(push_message)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking push_message changes.

  ## Examples

      iex> change_push_message(push_message)
      %Ecto.Changeset{source: %PushMessage{}}

  """
  def change_push_message(%PushMessage{} = push_message) do
    PushMessage.changeset(push_message, %{})
  end
end
