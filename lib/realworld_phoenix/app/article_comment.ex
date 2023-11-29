defmodule RealworldPhoenix.App.ArticleComment do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "article_comments" do
    belongs_to(
      :article,
      RealworldPhoenix.App.Article,
      primary_key: true,
      foreign_key: :article_id,
    )
    belongs_to(
      :comment,
      RealworldPhoenix.App.Comment,
      primary_key: true,
      foreign_key: :comment_id
    )

    timestamps()
  end

  @doc false
  def changeset(article_comment, attrs) do
    article_comment
    |> cast(attrs, [])
    |> validate_required([])
  end
end
