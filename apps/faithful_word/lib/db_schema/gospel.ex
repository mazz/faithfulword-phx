defmodule FaithfulWord.DB.Schema.Gospel do
  use Ecto.Schema
  import Ecto.Changeset


  # @primary_key {:id, :binary_id, autogenerate: true}
  # @foreign_key_type :binary_id
  schema "gospel" do
    field :absolute_id, :integer
    field :basename, :string
    field :uuid, Ecto.UUID

    # timestamps()
    has_many :mediagospel, FaithfulWord.DB.Schema.MediaGospel
    has_many :gospeltitle, FaithfulWord.DB.Schema.GospelTitle

  end

  @doc false
  def changeset(gospel, attrs) do
    gospel
    |> cast(attrs, [:absolute_id, :uuid, :basename])
    |> validate_required([:absolute_id, :uuid, :basename])
  end
end
