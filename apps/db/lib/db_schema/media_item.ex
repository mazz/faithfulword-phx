defmodule DB.Schema.MediaItem do
  use Ecto.Schema
  import Ecto.Changeset


  schema "mediaitems" do
    field :content_provider_link, :string
    field :ipfs_link, :string
    field :language_id, :string
    field :localizedname, :string
    field :medium, :string
    field :ordinal, :integer
    field :path, :string
    field :presenter_name, :string
    field :presented_at, :utc_datetime
    field :small_thumbnail_path, :string
    field :med_thumbnail_path, :string
    field :large_thumbnail_path, :string
    field :source_material, :string
    field :track_number, :integer
    field :tags, {:array, :string}
    field :media_category, DB.Type.MediaCategory
    field :uuid, Ecto.UUID
    field :playlist_id, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(media_item, attrs) do
    media_item
    |> cast(attrs, [:ordinal, :uuid, :track_number, :tags, :media_category, :medium, :localizedname, :path, :small_thumbnail_path, :med_thumbnail_path, :large_thumbnail_path, :content_provider_link, :ipfs_link, :language_id, :presenter_name, :presented_at, :source_material])
    |> validate_required([:ordinal, :uuid, :track_number, :tags, :media_category, :medium, :localizedname, :path, :small_thumbnail_path, :med_thumbnail_path, :large_thumbnail_path, :content_provider_link, :ipfs_link, :language_id, :presenter_name, :presented_at, :source_material])
  end
end
