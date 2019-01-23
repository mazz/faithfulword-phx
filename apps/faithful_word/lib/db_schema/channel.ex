defmodule FaithfulWord.DB.Schema.Channel do
  use Ecto.Schema
  import Ecto.Changeset

  schema "channels" do
    field :basename, :string
    field :ordinal, :integer
    field :uuid, Ecto.UUID
    field :org_id, :integer

    # timestamps()
  end

  @doc false
  def changeset(channel, attrs) do
    channel
    |> cast(attrs, [:uuid, :ordinal, :basename])
    |> validate_required([:uuid, :ordinal, :basename])
  end
end
