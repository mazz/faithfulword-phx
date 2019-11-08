defmodule Db.Schema.Gospel do
  use Ecto.Schema
  import Ecto.Changeset

  schema "gospel" do
    field :absolute_id, :integer
    field :basename, :string
    field :uuid, Ecto.UUID

    # timestamps()
    has_many :mediagospel, Db.Schema.MediaGospel
    has_many :gospeltitles, Db.Schema.GospelTitle
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(gospel, attrs) do
    gospel
    |> cast(attrs, [:absolute_id, :uuid, :basename])
    |> validate_required([:absolute_id, :uuid, :basename])
  end
end
