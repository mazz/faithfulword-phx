defmodule DB.Schema.Playlist do
  use Ecto.Schema
  import Ecto.Changeset


  schema "playlists" do
    field :language_id, :string
    field :localizedname, :string
    field :ordinal, :integer
    field :small_thumbnail_path, :string
    field :med_thumbnail_path, :string
    field :large_thumbnail_path, :string
    field :banner_path, :string
    field :uuid, Ecto.UUID
    field :channel_id, :integer
    timestamps(type: :utc_datetime)

    # timestamps()
  end

  @doc false
  def changeset(playlist, attrs) do
    playlist
    |> cast(attrs, [:ordinal, :uuid, :localizedname, :language_id, :large_thumbnail_path, :med_thumbnail_path, :small_thumbnail_path, :banner_path])
    |> validate_required([:ordinal, :uuid, :localizedname, :language_id, :large_thumbnail_path, :med_thumbnail_path, :small_thumbnail_path, :banner_path])
  end
end
