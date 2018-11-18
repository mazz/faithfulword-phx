defmodule FaithfulWord.Analytics.AppVersion do
  use Ecto.Schema
  import Ecto.Changeset


  # @primary_key {:id, :binary_id, autogenerate: true}
  # @foreign_key_type :binary_id
  schema "appversion" do
    field :android_supported, :boolean, default: false
    field :ios_supported, :boolean, default: false
    field :uuid, Ecto.UUID
    field :version_number, :string
    field :user_version, :string

    # timestamps()
  end

  @doc false
  def changeset(app_version, attrs) do
    app_version
    |> cast(attrs, [:uuid, :version_number, :user_version, :ios_supported, :android_supported])
    |> validate_required([:uuid, :version_number, :user_version, :ios_supported, :android_supported])
  end
end
