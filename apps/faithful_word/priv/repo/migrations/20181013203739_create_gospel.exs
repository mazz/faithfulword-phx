defmodule FaithfulWord.DB.Repo.Migrations.CreateGospel do
  use Ecto.Migration

  def change do
    create table(:gospel) do
      add :absolute_id, :integer
      add :uuid, :uuid
      add :basename, :string

      # timestamps()
    end

  end
end
