defmodule FaithfulWord.DB.Schema.MusicTitle do
  use Ecto.Schema
  import Ecto.Changeset


  # @primary_key {:id, :binary_id, autogenerate: true}
  # @foreign_key_type :binary_id
  schema "musictitles" do
    field :language_id, :string
    field :localizedname, :string
    field :uuid, Ecto.UUID
    field :music_id, :id

    # timestamps()
  end

  @doc false
  def changeset(music_title, attrs) do
    music_title
    |> cast(attrs, [:uuid, :localizedname, :language_id])
    |> validate_required([:uuid, :localizedname, :language_id])
  end
end
