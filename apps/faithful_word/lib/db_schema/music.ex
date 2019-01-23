defmodule FaithfulWord.DB.Schema.Music do
  use Ecto.Schema
  import Ecto.Changeset


  # @primary_key {:id, :binary_id, autogenerate: true}
  # @foreign_key_type :binary_id
  schema "music" do
    field :absolute_id, :integer
    field :basename, :string
    field :uuid, Ecto.UUID

    # timestamps()
    has_many :mediamusic, FaithfulWord.DB.Schema.MediaMusic
    has_many :musictitle, FaithfulWord.DB.Schema.MusicTitle

  end

  @doc false
  def changeset(music, attrs) do
    music
    |> cast(attrs, [:absolute_id, :uuid, :basename])
    |> validate_required([:absolute_id, :uuid, :basename])
  end
end
