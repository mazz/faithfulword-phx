defmodule FaithfulWord.DB.Schema.MediaItemTag do
  use Ecto.Schema
  import Ecto.Changeset


  schema "mediaitemtags" do
    field :uuid, Ecto.UUID
    field :tag_id, :integer
    field :mediaitem_id, :integer

    timestamps()
  end

  @doc false
  def changeset(media_item_tag, attrs) do
    media_item_tag
    |> cast(attrs, [:uuid])
    |> validate_required([:uuid])
  end
end
