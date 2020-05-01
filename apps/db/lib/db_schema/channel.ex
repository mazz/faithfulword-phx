defmodule Db.Schema.Channel do
  use Ecto.Schema
  import Ecto.Changeset
  alias Db.Type.ChannelHashId

  @derive {Jason.Encoder,
           only: [
             :basename,
             :ordinal,
             :small_thumbnail_path,
             :med_thumbnail_path,
             :large_thumbnail_path,
             :banner_path,
             :uuid,
             :org_id,
             :hash_id,
             :updated_at,
             :inserted_at
           ]}

  schema "channels" do
    field :basename, :string
    field :ordinal, :integer
    field :small_thumbnail_path, :string
    field :med_thumbnail_path, :string
    field :large_thumbnail_path, :string
    field :banner_path, :string
    field :uuid, Ecto.UUID
    field :org_id, :id
    field :hash_id, :string

    has_many :playlists, Db.Schema.Playlist, on_delete: :delete_all

    timestamps(type: :utc_datetime)

    # timestamps()
  end

  @doc false
  def changeset(channel, attrs) do
    channel
    |> cast(attrs, [
      :uuid,
      :ordinal,
      :basename,
      :small_thumbnail_path,
      :med_thumbnail_path,
      :large_thumbnail_path,
      :banner_path,
      :org_id
    ])
    |> validate_required([
      :uuid,
      :ordinal,
      :basename,
      :org_id
    ])
  end

  @doc """
  Generate hash ID for channels

  ## Examples

      iex> Db.Schema.MediaItem.changeset_generate_hash_id(%Db.Schema.Video{id: 42, hash_id: nil})
      #Ecto.Changeset<action: nil, changes: %{hash_id: \"4VyJ\"}, errors: [], data: #Db.Schema.Video<>, valid?: true>
  """
  def changeset_generate_hash_id(channel) do
    change(channel, hash_id: ChannelHashId.encode(channel.id))
  end
end
