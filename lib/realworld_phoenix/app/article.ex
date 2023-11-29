defmodule RealworldPhoenix.App.Article do
  use Ecto.Schema
  import Ecto.Changeset

  schema "articles" do
    field :body, :string
    field :description, :string
    field :slug, :string
    field :title, :string
    belongs_to(
      :author,
      RealworldPhoenix.App.Profile,
      foreign_key: :author_id
    )
    has_many(
      :article_comments,
      RealworldPhoenix.App.ArticleComment,
      foreign_key: :article_id
    )
    has_many(
      :article_favorites,
      RealworldPhoenix.App.ArticleFavorite,
      foreign_key: :article_id
    )
    has_many(
      :favorited_profiles,
      through: [:article_favorites, :profile]
    )
    has_many(
      :comments,
      through: [:article_comments, :comment]
    )
    has_many(
      :followers,
      through: [:author, :followers]
    )
    many_to_many(
      :tags,
      RealworldPhoenix.App.Tag,
      join_through: RealworldPhoenix.App.ArticleTag,
      on_replace: :delete
    )

    timestamps()
  end

  @doc false
  def changeset(article, attrs) do
    article
    |> cast(attrs, [:slug, :title, :description, :body])
    |> validate_required([:slug, :title, :description, :body])
    |> unique_constraint(:slug)
    |> cast_assoc(:tags, with: &RealworldPhoenix.App.Tag.changeset/2)
  end
end
