defmodule FaithfulWord.Content.BookTitle do
  use Ecto.Schema
  import Ecto.Changeset


  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "booktitle" do
    field :language_id, :string
    field :localizedname, :string
    field :uuid, Ecto.UUID
    field :book_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(book_title, attrs) do
    book_title
    |> cast(attrs, [:uuid, :localizedname, :language_id])
    |> validate_required([:uuid, :localizedname, :language_id])
  end
end
