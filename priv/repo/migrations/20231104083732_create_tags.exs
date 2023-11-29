defmodule RealworldPhoenix.Repo.Migrations.CreateTags do
  use Ecto.Migration

  def change do
    create table(:tags) do
      add :label, :string, size: 255

      timestamps()
    end
  end
end
