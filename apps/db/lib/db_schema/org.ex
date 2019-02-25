defmodule DB.Schema.Org do
  use Ecto.Schema
  import Ecto.Changeset


  schema "orgs" do
    field :basename, :string
    field :small_thumbnail_path, :string
    field :med_thumbnail_path, :string
    field :large_thumbnail_path, :string
    field :banner_path, :string
    field :uuid, Ecto.UUID
    timestamps(type: :utc_datetime)

    # timestamps()
  end

  @doc false
  def changeset(org, attrs) do
    org
    |> cast(attrs, [:uuid, :basename, :large_thumbnail_path, :med_thumbnail_path, :small_thumbnail_path, :banner_path])
    |> validate_required([:uuid, :basename, :large_thumbnail_path, :med_thumbnail_path, :small_thumbnail_path, :banner_path])
  end
end
