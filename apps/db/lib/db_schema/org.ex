defmodule DB.Schema.Org do
  use Ecto.Schema
  import Ecto.Changeset


  schema "orgs" do
    field :basename, :string
    field :uuid, Ecto.UUID

    # timestamps()
  end

  @doc false
  def changeset(org, attrs) do
    org
    |> cast(attrs, [:uuid, :basename])
    |> validate_required([:uuid, :basename])
  end
end
