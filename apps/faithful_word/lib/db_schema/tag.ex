defmodule FaithfulWord.DB.Schema.Tag do
  use Ecto.Schema
  import Ecto.Changeset


  schema "tags" do
    field :basename, :string
    field :description, :string
    field :uuid, Ecto.UUID
  end

  @doc false
  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:uuid, :basename, :description])
    |> validate_required([:uuid, :basename, :description])
  end
end
