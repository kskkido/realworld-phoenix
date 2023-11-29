defmodule RealworldPhoenix.Repo.Migrations.CreateProfiles do
  use Ecto.Migration

  def change do
    create table(:profiles) do
      add :username, :text, null: false
      add :bio, :text
      add :image, :text
      add :user_id, references(:users, on_delete: :nothing)


      timestamps()
    end

    create unique_index(:profiles, [:username])
    create index(:profiles, [:user_id])
  end
end
