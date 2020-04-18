defmodule Db.Schema.ClientDevice do
  use Ecto.Schema
  import Ecto.Changeset

  schema "clientdevices" do
    field :apns_token, :string
    field :firebase_token, :string
    field :preferred_language, :string
    field :user_agent, :string
    # field :org_id, :integer
    field :user_version, :string
    # field :user_uuid, Ecto.UUID
    field :uuid, Ecto.UUID

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(client_device, attrs) do
    client_device
    |> cast(attrs, [
      :uuid,
      :firebase_token,
      :apns_token,
      :preferred_language,
      :user_agent,
      # :org_id,
      :user_version
    ])
    |> validate_required([
      :uuid,
      :firebase_token,
      :apns_token,
      :preferred_language,
      :user_agent
      # :org_id
      ])
  end
end
