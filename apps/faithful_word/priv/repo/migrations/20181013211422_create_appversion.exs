defmodule FaithfulWord.Repo.Migrations.CreateAppversion do
  use Ecto.Migration

  def change do
    create table(:appversion) do
      # add :id, :binary_id, primary_key: true
      add :uuid, :uuid
      add :version_number, :string
      add :user_version, :string
      add :ios_supported, :boolean, default: false, null: false
      add :android_supported, :boolean, default: false, null: false

      # timestamps()
    end

  end
end
