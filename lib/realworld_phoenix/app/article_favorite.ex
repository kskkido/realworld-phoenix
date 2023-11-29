defmodule RealworldPhoenix.App.ArticleFavorite do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "article_favorites" do
    belongs_to(
      :article,
      RealworldPhoenix.App.Article,
      primary_key: true,
      foreign_key: :article_id
    )
    belongs_to(
      :profile,
      RealworldPhoenix.App.Profile,
      primary_key: true,
      foreign_key: :profile_id
    )

    timestamps()
  end

  @doc false
  def changeset(article_favorite, attrs) do
    article_favorite
    |> cast(attrs, [])
    |> validate_required([])
  end
end
