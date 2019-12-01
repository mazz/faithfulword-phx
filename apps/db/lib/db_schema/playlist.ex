defmodule Db.Schema.Playlist do
  use Ecto.Schema
  import Ecto.Changeset
  alias Db.Type.PlaylistHashId

  @derive {Jason.Encoder,
   only: [
     :basename,
     :ordinal,
     :small_thumbnail_path,
     :med_thumbnail_path,
     :large_thumbnail_path,
     :banner_path,
     :uuid,
     :channel_id,
     :org_id,
     :media_category,
     :hash_id,
     #  :playlist_titles,
     :multilanguage,
     :updated_at,
     :inserted_at
   ]}

  schema "playlists" do
    # field :language_id, :string
    # field :localizedname, :string
    field :ordinal, :integer
    field :basename, :string
    field :small_thumbnail_path, :string
    field :med_thumbnail_path, :string
    field :large_thumbnail_path, :string
    field :banner_path, :string
    field :uuid, Ecto.UUID
    field :channel_id, :id
    field :media_category, Db.Type.MediaCategory
    field :hash_id, :string
    field :multilanguage, :boolean, default: false

    has_many :mediaitems, Db.Schema.MediaItem
    has_many :playlist_titles, Db.Schema.PlaylistTitle

    timestamps(type: :utc_datetime)

    # timestamps()
  end

  @doc false
  def changeset(playlist, attrs) do
    playlist
    |> cast(attrs, [
      :ordinal,
      :uuid,
      :media_category,
      :channel_id
    ])
    |> validate_required([
      :ordinal,
      :uuid,
      :media_category,
      :channel_id
    ])
  end

  @doc """
  Generate hash ID for media items

  ## Examples

      iex> Db.Schema.MediaItem.changeset_generate_hash_id(%Db.Schema.Video{id: 42, hash_id: nil})
      #Ecto.Changeset<action: nil, changes: %{hash_id: \"4VyJ\"}, errors: [], data: #Db.Schema.Video<>, valid?: true>
  """
  def changeset_generate_hash_id(playlist) do
    change(playlist, hash_id: PlaylistHashId.encode(playlist.id))
  end
end
