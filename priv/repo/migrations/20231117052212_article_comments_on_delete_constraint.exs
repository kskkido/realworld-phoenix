defmodule RealworldPhoenix.Repo.Migrations.ArticleCommentsOnDeleteConstraint do
  use Ecto.Migration

  def change do
    drop constraint(:article_comments, "article_comments_article_id_fkey")
    drop constraint(:article_comments, "article_comments_comment_id_fkey")
    alter table(:article_comments) do
      modify :article_id, references(:articles, on_delete: :delete_all)
      modify :comment_id, references(:comments, on_delete: :delete_all)
    end
  end
end
