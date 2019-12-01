defmodule Db.Schema.PushMessage do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder,
           only: [
             :title,
             :message,
             :sent,
             :uuid,
             :org_id,
             :updated_at,
             :inserted_at
           ]}

  schema "pushmessages" do
    # field :created_at, :utc_datetime
    field :message, :string, size: 4096
    field :sent, :boolean, default: false
    field :title, :string
    # field :updated_at, :utc_datetime
    field :org_id, :integer
    field :uuid, Ecto.UUID

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(push_message, attrs) do
    push_message
    |> cast(attrs, [
      :uuid,
      :title,
      :message,
      :sent,
      :org_id
    ])
    |> validate_required([
      :uuid,
      :title,
      :message,
      :sent,
      :org_id
    ])
  end
end
