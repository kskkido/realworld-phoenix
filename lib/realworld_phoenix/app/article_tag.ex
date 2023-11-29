defmodule RealworldPhoenix.App.ArticleTag do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "article_tags" do
    belongs_to(
      :article,
      RealworldPhoenix.App.Article,
      foreign_key: :article_id,
      primary_key: true
    )
    belongs_to(
      :tag,
      RealworldPhoenix.App.Tag,
      foreign_key: :tag_id,
      primary_key: true
    )


    timestamps()
  end

  @doc false
  def changeset(article_tag, attrs) do
    article_tag
    |> cast(attrs, [])
    |> validate_required([])
  end
end
