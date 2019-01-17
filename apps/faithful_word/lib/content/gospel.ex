defmodule FaithfulWord.Content.Gospel do
  use Ecto.Schema
  import Ecto.Changeset


  # @primary_key {:id, :binary_id, autogenerate: true}
  # @foreign_key_type :binary_id
  schema "gospel" do
    field :absolute_id, :integer
    field :basename, :string
    field :uuid, Ecto.UUID

    # timestamps()
    has_many :mediagospel, FaithfulWord.Content.MediaGospel
    has_many :gospeltitle, FaithfulWord.Content.GospelTitle

  end

  @doc false
  def changeset(gospel, attrs) do
    gospel
    |> cast(attrs, [:absolute_id, :uuid, :basename])
    |> validate_required([:absolute_id, :uuid, :basename])
  end
end
