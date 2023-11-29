defmodule RealworldPhoenix.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :body, :text, null: false
      add :author_id, references(:profiles, on_delete: :nothing)

      timestamps()
    end

    create index(:comments, [:author_id])
  end
end
