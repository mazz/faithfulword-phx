defmodule Db.Schema.MediaItem do
  use Ecto.Schema
  import Ecto.Changeset
  alias Db.Type.MediaItemHashId

  @derive {Jason.Encoder,
           only: [
             :localizedname,
             :ordinal,
             :small_thumbnail_path,
             :med_thumbnail_path,
             :large_thumbnail_path,
             :banner_path,
             :content_provider_link,
             :ipfs_link,
             :language_id,
             :medium,
             :path,
             :presenter_name,
             :uuid,
             :channel_id,
             :playlist_id,
             :org_id,
             :media_category,
             :hash_id,
             :multilanguage,
             :presented_at,
             :published_at,
             :updated_at,
             :inserted_at
           ]}

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
    field :media_category, Db.Type.MediaCategory
    field :uuid, Ecto.UUID
    field :playlist_id, :integer
    field :org_id, :integer
    field :published_at, :utc_datetime, null: true
    field :hash_id, :string
    field :duration, :float, default: 0.0

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(media_item, attrs) do
    types = %{duration: :float}

    media_item
    |> cast(attrs, [
      :ordinal,
      :uuid,
      :playlist_id,
      :org_id,
      :track_number,
      :tags,
      :media_category,
      :medium,
      :localizedname,
      :path,
      :small_thumbnail_path,
      :med_thumbnail_path,
      :large_thumbnail_path,
      :content_provider_link,
      :ipfs_link,
      :language_id,
      :presenter_name,
      :presented_at,
      :source_material,
      :hash_id,
      :duration
    ])
    |> validate_required([
      :ordinal,
      :uuid,
      :playlist_id,
      :org_id,
      # :track_number,
      # :tags,
      :media_category,
      :medium,
      :localizedname,
      :path,
      # :small_thumbnail_path,
      # :med_thumbnail_path,
      # :large_thumbnail_path,
      # :content_provider_link,
      # :ipfs_link,
      :language_id
      # :presenter_name,
      # :presented_at,
      # :source_material,
      # :hash_id,
      # :duration
    ])
  end

  @doc """
  Generate hash ID for media items

  ## Examples

      iex> Db.Schema.MediaItem.changeset_generate_hash_id(%Db.Schema.Video{id: 42, hash_id: nil})
      #Ecto.Changeset<action: nil, changes: %{hash_id: \"4VyJ\"}, errors: [], data: #Db.Schema.Video<>, valid?: true>
  """
  def changeset_generate_hash_id(media_item) do
    change(media_item, hash_id: MediaItemHashId.encode(media_item.id))
  end
end
