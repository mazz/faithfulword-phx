defmodule FaithfulWord.DB.Repo.Migrations.CreateGospeltitle do
  use Ecto.Migration

  def change do
    create table(:gospeltitle) do
      # add :id, :binary_id, primary_key: true
      add :uuid, :uuid
      add :localizedname, :string
      add :language_id, :string
      add :gospel_id, references(:gospel, on_delete: :nothing)

      # timestamps()
    end

    create index(:gospeltitle, [:gospel_id])
  end
end
