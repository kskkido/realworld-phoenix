defmodule RealworldPhoenix.Repo.Migrations.CreateArticleFavorites do
  use Ecto.Migration

  def change do
    create table(:article_favorites, primary_key: false) do
      add :article_id, references(:articles, on_delete: :nothing), primary_key: true
      add :profile_id, references(:profiles, on_delete: :nothing), primary_key: true

      timestamps()
    end

    create index(:article_favorites, [:article_id])
  end
end
