defmodule FaithfulWord.DB.Schema.Playlist do
  use Ecto.Schema
  import Ecto.Changeset


  schema "playlists" do
    field :language_id, :string
    field :localizedname, :string
    field :ordinal, :integer
    field :uuid, Ecto.UUID
    field :channel_id, :integer

    # timestamps()
  end

  @doc false
  def changeset(playlist, attrs) do
    playlist
    |> cast(attrs, [:ordinal, :uuid, :localizedname, :language_id])
    |> validate_required([:ordinal, :uuid, :localizedname, :language_id])
  end
end
