defmodule Db.Schema.Music do
  use Ecto.Schema
  import Ecto.Changeset

  schema "music" do
    field :absolute_id, :integer
    field :basename, :string
    field :uuid, Ecto.UUID

    # timestamps()
    has_many :mediamusic, Db.Schema.MediaMusic
    has_many :musictitle, Db.Schema.MusicTitle
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(music, attrs) do
    music
    |> cast(attrs, [:absolute_id, :uuid, :basename])
    |> validate_required([:absolute_id, :uuid, :basename])
  end
end
