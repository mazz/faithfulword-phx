defmodule FaithfulWord.Content.Book do
  use Ecto.Schema
  import Ecto.Changeset


  # @primary_key {:id, :serial, autogenerate: true}
  # @foreign_key_type :serial
  schema "book" do
    # field :id, :integer, autogenerate: true, primary_key: true
    field :absolute_id, :integer
    field :basename, :string
    field :uuid, Ecto.UUID

    has_many :chapter, FaithfulWord.Chapter
    has_many :booktitle, FaithfulWord.BookTitle
  end

  @doc false
  def changeset(book, attrs) do
    book
    |> cast(attrs, [:absolute_id, :uuid, :basename])
    |> validate_required([:absolute_id, :uuid, :basename])
  end
end

