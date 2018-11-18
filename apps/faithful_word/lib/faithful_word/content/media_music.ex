defmodule FaithfulWord.Content.MediaMusic do
  use Ecto.Schema
  import Ecto.Changeset


  # @primary_key {:id, :binary_id, autogenerate: true}
  # @foreign_key_type :binary_id
  schema "mediamusic" do
    field :absolute_id, :integer
    field :language_id, :string
    field :localizedname, :string
    field :path, :string
    field :large_thumbnail_path, :string
    field :small_thumbnail_path, :string
    field :presenter_name, :string
    field :source_material, :string
    field :track_number, :integer
    field :uuid, Ecto.UUID
    field :music_id, :id

    # timestamps()
  end

  @doc false
  def changeset(media_music, attrs) do
    media_music
    |> cast(attrs, [:absolute_id, :uuid, :track_number, :localizedname, :path, :large_thumbnail_path, :small_thumbnail_path, :language_id, :presenter_name, :source_material])
    |> validate_required([:absolute_id, :uuid, :track_number, :localizedname, :path, :large_thumbnail_path, :small_thumbnail_path, :language_id, :presenter_name, :source_material])
  end
end
