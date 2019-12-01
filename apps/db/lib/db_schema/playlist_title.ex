defmodule Db.Schema.PlaylistTitle do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder,
           only: [
             :language_id,
             :localizedname,
             :uuid,
             :playlist_id,
             :updated_at,
             :inserted_at
           ]}

  schema "playlist_titles" do
    field :language_id, :string
    field :localizedname, :string
    field :uuid, Ecto.UUID
    field :playlist_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(playlist_title, attrs) do
    playlist_title
    |> cast(attrs, [:uuid, :localizedname, :language_id, :playlist_id])
    |> validate_required([:uuid, :localizedname, :language_id, :playlist_id])
  end
end
