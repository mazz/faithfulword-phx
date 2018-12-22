defmodule FaithfulWord.DB.Repo.Migrations.CreatePushmessage do
  use Ecto.Migration

  def change do
    create table(:pushmessage) do
      # add :id, :binary_id, primary_key: true
      add :uuid, :uuid
      add :created_at, :utc_datetime
      add :updated_at, :utc_datetime
      add :title, :string
      add :message, :string, size: 4096
      add :sent, :boolean, default: false, null: false

      # timestamps()
    end

  end
end
