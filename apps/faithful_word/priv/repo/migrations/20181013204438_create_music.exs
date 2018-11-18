defmodule FaithfulWord.Repo.Migrations.CreateMusic do
  use Ecto.Migration

  def change do
    create table(:music) do
      # add :id, :binary_id, primary_key: true
      add :absolute_id, :integer
      add :uuid, :uuid
      add :basename, :string

      # timestamps()
    end

  end
end
