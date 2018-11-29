defmodule FaithfulWord.Content.Chapter do
  use Ecto.Schema
  import Ecto.Changeset


  # @primary_key {:id, :binary_id, autogenerate: true}
  # @foreign_key_type :binary_id
  schema "chapter" do
    field :absolute_id, :integer
    field :basename, :string
    field :uuid, Ecto.UUID
    field :book_id, :id

    has_many :mediachapter, FaithfulWord.MediaChapter
    # timestamps()
  end

  @doc false
  def changeset(chapter, attrs) do
    chapter
    |> cast(attrs, [:absolute_id, :uuid, :basename])
    |> validate_required([:absolute_id, :uuid, :basename])
  end
end