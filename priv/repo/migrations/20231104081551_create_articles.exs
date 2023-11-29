defmodule RealworldPhoenix.Repo.Migrations.CreateArticles do
  use Ecto.Migration

  def change do
    create table(:articles) do
      add :slug, :text
      add :title, :string, size: 255
      add :description, :text
      add :body, :text
      add :author_id, references(:profiles, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:articles, [:slug])
    create index(:articles, [:author_id])
  end
end
