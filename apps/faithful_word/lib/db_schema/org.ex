defmodule FaithfulWord.DB.Schema.Org do
  use Ecto.Schema
  import Ecto.Changeset


  # @primary_key {:id, :binary_id, autogenerate: true}
  # @foreign_key_type :binary_id
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
