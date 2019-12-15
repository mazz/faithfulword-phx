defmodule FaithfulWord.PushNotifications do
  @moduledoc """
  The PushNotifications context.
  """
  import Ecto.Query, warn: false
  alias Db.Repo
  alias Db.Schema.PushMessage
  require Logger

  def send_pushmessage_now(message) do
    [
      "fo6cdLGfU7k:APA91bHKQ3d7l8z6JlepC-xX4iUWicuNNxlAq7GNpVogSv47Nb2gkF2DBME6NFAomtiae-8QVkOvNZQbsM-9GqutPj1a94OKL_sG9OAb9qBbMhH81-6yo7v7MGYhkI7aUF5LD09JHZ_w"
    ]
    |> Pigeon.FCM.Notification.new()
    |> Pigeon.FCM.Notification.put_notification(%{"title" => message.title, "body" => message.message})
    |> Pigeon.FCM.Notification.put_data(%{
      "deeplink" => "https://site/m/j4X8",
      "entity_type" => "mediaitem",
      "entity_uuid" => "82d66cbb-ae6a-4b4e-bbf5-39ee2bb4fc0e",
      "org" => "fwbcapp",
      "image_thumbnail_path" => "thumbs/lg/0005-0026-Psalm81-en.jpg",
      "image_thumbnail_url" => "https://i.ytimg.com/vi/zPNyuv3fw_4/hqdefault.jpg",
      "mutable-content" => true,
      "version" => "1.3"
    })
    |> Pigeon.FCM.Notification.put_mutable_content(true)
    |> Pigeon.FCM.push(on_response: &handle_push/1)
    # |> Pigeon.FCM.push()
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
