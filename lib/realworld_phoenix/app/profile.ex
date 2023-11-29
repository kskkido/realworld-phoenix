defmodule RealworldPhoenix.App.Profile do
  use Ecto.Schema
  import Ecto.Changeset

  schema "profiles" do
    field :bio, :string
    field :image, :string
    field :username, :string
    belongs_to(
      :user,
      RealworldPhoenix.Accounts.User,
      foreign_key: :user_id
    )
    has_many(
      :comments,
      RealworldPhoenix.App.Comment,
      foreign_key: :author_id
    )
    has_many(
      :articles,
      RealworldPhoenix.App.Article,
      foreign_key: :author_id
    )
    has_many(
      :article_favorites,
      RealworldPhoenix.App.ArticleFavorite,
      foreign_key: :profile_id
    )
    has_many(
      :favorite_articles,
      through: [:article_favorites, :article]
    )
    has_many(
      :profile_followers,
      RealworldPhoenix.App.ProfileFollower,
      foreign_key: :following_id
    )
    has_many(
      :followers,
      through: [:profile_followers, :follower]
    )
    has_many(
      :profile_following,
      RealworldPhoenix.App.ProfileFollower,
      foreign_key: :follower_id
    )
    has_many(
      :following,
      through: [:profile_following, :following]
    )

    timestamps()
  end

  @doc false
  def changeset(profile, attrs) do
    profile
    |> cast(attrs, [:username, :bio, :image])
    |> validate_required([:username])
    |> unique_constraint(:username)
  end

  def following(profile, following) do
    profile.following
    |> Enum.map(&(&1.id))
    |> Enum.member?(following.id)
  end

  def favorited(profile, article) do
    profile.favorite_articles
    |> Enum.map(&(&1.id))
    |> Enum.member?(article.id)
  end
end
