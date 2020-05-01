defmodule Db.Schema.Book do
  use Ecto.Schema
  import Ecto.Changeset

  # @primary_key {:id, :serial, autogenerate: true}
  # @foreign_key_type :serial
  schema "books" do
    # field :id, :integer, autogenerate: true, primary_key: true
    field :absolute_id, :integer
    field :basename, :string
    field :uuid, Ecto.UUID

    has_many :chapters, Db.Schema.Chapter
    has_many :booktitles, Db.Schema.BookTitle
  end

  @doc false
  def changeset(book, attrs) do
    book
    |> cast(attrs, [:absolute_id, :uuid, :basename])
    |> validate_required([:absolute_id, :uuid, :basename])
  end
end
