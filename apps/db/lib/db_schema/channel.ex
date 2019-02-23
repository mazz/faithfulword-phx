defmodule DB.Schema.Channel do
  use Ecto.Schema
  import Ecto.Changeset

  schema "channels" do
    field :basename, :string
    field :ordinal, :integer
    field :small_thumbnail_path, :string
    field :med_thumbnail_path, :string
    field :large_thumbnail_path, :string
    field :banner_path, :string
    field :uuid, Ecto.UUID
    field :org_id, :integer

    # timestamps()
  end

  @doc false
  def changeset(channel, attrs) do
    channel
    |> cast(attrs, [:uuid, :ordinal, :basename, :large_thumbnail_path, :med_thumbnail_path, :small_thumbnail_path, :banner_path])
    |> validate_required([:uuid, :ordinal, :basename, :large_thumbnail_path, :med_thumbnail_path, :small_thumbnail_path, :banner_path])
  end
end
