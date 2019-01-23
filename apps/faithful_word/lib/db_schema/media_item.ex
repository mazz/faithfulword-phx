defmodule FaithfulWord.DB.Schema.MediaItem do
  use Ecto.Schema
  import Ecto.Changeset


  schema "mediaitems" do
    field :content_provider_link, :string
    field :ipfs_link, :string
    field :language_id, :string
    field :large_thumbnail_path, :string
    field :localizedname, :string
    field :medium, :string
    field :ordinal, :integer
    field :path, :string
    field :presenter_name, :string
    field :small_thumbnail_path, :string
    field :source_material, :string
    field :track_number, :integer
    field :uuid, Ecto.UUID
    field :playlist_id, :integer

    timestamps()
  end

  @doc false
  def changeset(media_item, attrs) do
    media_item
    |> cast(attrs, [:ordinal, :uuid, :track_number, :medium, :localizedname, :path, :small_thumbnail_path, :large_thumbnail_path, :content_provider_link, :ipfs_link, :language_id, :presenter_name, :source_material])
    |> validate_required([:ordinal, :uuid, :track_number, :medium, :localizedname, :path, :small_thumbnail_path, :large_thumbnail_path, :content_provider_link, :ipfs_link, :language_id, :presenter_name, :source_material])
  end
end
