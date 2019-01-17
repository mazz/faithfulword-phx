defmodule FaithfulWord.Content.GospelTitle do
  use Ecto.Schema
  import Ecto.Changeset


  # @primary_key {:id, :binary_id, autogenerate: true}
  # @foreign_key_type :binary_id
  schema "gospeltitle" do
    field :language_id, :string
    field :localizedname, :string
    field :uuid, Ecto.UUID
    field :gospel_id, :id

    # timestamps()
  end

  @doc false
  def changeset(gospel_title, attrs) do
    gospel_title
    |> cast(attrs, [:uuid, :localizedname, :language_id])
    |> validate_required([:uuid, :localizedname, :language_id])
  end
end
