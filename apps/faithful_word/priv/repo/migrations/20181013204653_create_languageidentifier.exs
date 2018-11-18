defmodule FaithfulWord.Repo.Migrations.CreateLanguageidentifier do
  use Ecto.Migration

  def change do
    create table(:languageidentifier) do
      # add :id, :binary_id, primary_key: true
      add :uuid, :uuid
      add :identifier, :string
      add :source_material, :string
      add :supported, :boolean, default: false, null: false

      # timestamps()
    end

  end
end
