defmodule RealworldPhoenix.Repo.Migrations.CreateArticleComments do
  use Ecto.Migration

  def change do
    create table(:article_comments, primary_key: false) do
      add :article_id, references(:articles, on_delete: :nothing), primary_key: true
      add :comment_id, references(:comments, on_delete: :nothing), primary_key: true

      timestamps()
    end

    create index(:article_comments, [:article_id])
    create index(:article_comments, [:comment_id])
  end
end
