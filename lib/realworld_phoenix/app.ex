defmodule RealworldPhoenix.App do
  @moduledoc """
  The App context.
  """

  require Logger
  import Ecto.Query, warn: false
  alias RealworldPhoenix.Repo
  alias RealworldPhoenix.App.Profile
  alias RealworldPhoenix.App.Article
  alias RealworldPhoenix.App.ArticleFavorite
  alias RealworldPhoenix.App.ProfileFollower

  @doc """
  Returns the list of profiles.

  ## Examples

      iex> list_profiles()
      [%Profile{}, ...]

  """
  def list_profiles do
    Repo.all(Profile)
  end

  @doc """
  Gets a single profile.

  Raises `Ecto.NoResultsError` if the Profile does not exist.

  ## Examples

      iex> get_profile!(123)
      %Profile{}

      iex> get_profile!(456)
      ** (Ecto.NoResultsError)

  """
  def get_profile!(id) do
    Repo.get!(Profile, id)
    |> Repo.preload([:followers])
    |> Repo.preload([:following])
    |> Repo.preload([:favorite_articles])
  end

  def get_profile_by!(constraint \\ %{}) do
    Profile
    |> Repo.get_by!(constraint)
    |> Repo.preload([:followers])
    |> Repo.preload([:following])
    |> Repo.preload([:favorite_articles])
  end

  def get_profile_by_user!(user) do
    Profile
    |> Repo.get_by!(user_id: user.id)
    |> Repo.preload([:followers])
    |> Repo.preload([:following])
    |> Repo.preload([:favorite_articles])
  end

  @doc """
  Creates a profile.

  ## Examples

      iex> create_profile(%{field: value})
      {:ok, %Profile{}}

      iex> create_profile(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_profile(attrs \\ %{}) do
    %Profile{}
    |> Profile.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a profile.

  ## Examples

      iex> update_profile(profile, %{field: new_value})
      {:ok, %Profile{}}

      iex> update_profile(profile, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_profile(%Profile{} = profile, attrs) do
    profile
    |> Profile.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a profile.

  ## Examples

      iex> delete_profile(profile)
      {:ok, %Profile{}}

      iex> delete_profile(profile)
      {:error, %Ecto.Changeset{}}

  """
  def delete_profile(%Profile{} = profile) do
    Repo.delete(profile)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking profile changes.

  ## Examples

      iex> change_profile(profile)
      %Ecto.Changeset{data: %Profile{}}

  """
  def change_profile(%Profile{} = profile, attrs \\ %{}) do
    Profile.changeset(profile, attrs)
  end

  def toggle_follow_profile(following, follower) do
    following.profile_followers
    |> Enum.find(&(&1.follower_id == follower.id))
    |> case do
      :nil -> follow_profile(following, follower)
      profile_follower -> unfollow_profile(profile_follower)
    end
  end

  def follow_profile(following, follower) do
    Repo.transaction fn -> 
      create_profile_follower(following, follower)
    end
  end

  def unfollow_profile(profile_follower) do
    Repo.transaction fn ->
      delete_profile_follower(profile_follower)
    end
  end


  @doc """
  Returns the list of articles.

  ## Examples

      iex> list_articles()
      [%Article{}, ...]

  """
  def list_articles(constraint \\ %{}) do
    Article
    |> order_by(^constraint)
    |> Repo.all()
    |> Repo.preload([:author])
    |> Repo.preload([:article_favorites])
  end

  def list_articles_feed(constraint \\ %{}) do
    limit = constraint[:limit] || 20
    offset = constraint[:offset] || 0

    from(
      a in Article,
      left_join: af in ArticleFavorite,
      on: a.id == af.article_id,
      left_join: pf in ProfileFollower,
      on: a.author_id == pf.following_id,
      where:
        fragment("((? :: INT) IS NULL OR ? = ?)", ^constraint[:follower_id], ^constraint[:follower_id], pf.follower_id) and
        fragment("((? :: INT) IS NULL OR ? = ?)", ^constraint[:author_id], ^constraint[:author_id], a.author_id) and
        fragment("((? :: INT) IS NULL OR ? = ?)", ^constraint[:favorited_by_id], ^constraint[:favorited_by_id], af.profile_id),
      group_by: a.id,
      limit: ^limit,
      offset: ^offset
    )
    |> order_by(desc: :inserted_at)
    |> Repo.all()
    |> Repo.preload([:author])
    |> Repo.preload([:article_favorites])
    |> Repo.preload([:tags])
  end

  def get_article(id) do
    Repo.get(Article, id)
    |> Repo.preload([:author, {:author, [:followers, :following]}])
    |> Repo.preload([:article_favorites])
    |> Repo.preload([:comments, {:comments, [:author] }])
  end
  @doc """
  Gets a single article.

  Raises `Ecto.NoResultsError` if the Article does not exist.

  ## Examples

      iex> get_article!(123)
      %Article{}

      iex> get_article!(456)
      ** (Ecto.NoResultsError)

  """
  def get_article!(id) do
    Repo.get!(Article, id)
    |> Repo.preload([:author, {:author, [:followers, :following]}])
    |> Repo.preload([:article_favorites])
    |> Repo.preload([:comments, {:comments, [:author] }])
    |> Repo.preload([:tags])
  end

  def get_article_by!(constraint \\ %{}) do
    Article
    |> Repo.get_by!(constraint)
    |> Repo.preload([:author, {:author, [:followers, :following]}])
    |> Repo.preload([:article_favorites])
    |> Repo.preload([:comments, {:comments, [:author] }])
    |> Repo.preload([:tags])
  end

  @doc """
  Creates a article.

  ## Examples

      iex> create_article(%{field: value})
      {:ok, %Article{}}

      iex> create_article(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_article(author, attrs \\ %{}) do
    Ecto.build_assoc(author, :articles, %Article{})
    |> Article.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a article.

  ## Examples

      iex> update_article(article, %{field: new_value})
      {:ok, %Article{}}

      iex> update_article(article, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_article(%Article{} = article, attrs) do
    article
    |> Article.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a article.

  ## Examples

      iex> delete_article(article)
      {:ok, %Article{}}

      iex> delete_article(article)
      {:error, %Ecto.Changeset{}}

  """
  def delete_article(%Article{} = article) do
    Repo.delete(article)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking article changes.

  ## Examples

      iex> change_article(article)
      %Ecto.Changeset{data: %Article{}}

  """
  def change_article(%Article{} = article, attrs \\ %{}) do
    Article.changeset(article, attrs)
  end

  def toggle_favorite_article(profile, article) do
    article.article_favorites
    |> Enum.find(&(&1.profile_id == profile.id))
    |> case do
      :nil -> favorite_article(profile, article)
      article_favorite -> unfavorite_article(article_favorite)
    end
  end

  def favorite_article(profile, article) do
    Repo.transaction fn -> 
      create_article_favorite(profile, article)
      get_article(article.id)
    end
  end

  def unfavorite_article(article_favorite) do
    Repo.transaction fn ->
      delete_article_favorite(article_favorite)
      get_article(article_favorite.article_id)
    end
  end

  @doc """
  Returns the list of article_favorites.

  ## Examples

      iex> list_article_favorites()
      [%ArticleFavorite{}, ...]

  """
  def list_article_favorites do
    Repo.all(ArticleFavorite)
  end

  @doc """
  Gets a single article_favorite.

  Raises `Ecto.NoResultsError` if the Article favorite does not exist.

  ## Examples

      iex> get_article_favorite!(123)
      %ArticleFavorite{}

      iex> get_article_favorite!(456)
      ** (Ecto.NoResultsError)

  """
  def get_article_favorite!(id), do: Repo.get!(ArticleFavorite, id)

  @doc """
  Creates a article_favorite.

  ## Examples

      iex> create_article_favorite(%{field: value})
      {:ok, %ArticleFavorite{}}

      iex> create_article_favorite(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_article_favorite(profile, article, attrs \\ %{}) do
    profile
    |> Ecto.build_assoc(:article_favorites)
    |> ArticleFavorite.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:article, article)
    |> Repo.insert()
  end

  @doc """
  Updates a article_favorite.

  ## Examples

      iex> update_article_favorite(article_favorite, %{field: new_value})
      {:ok, %ArticleFavorite{}}

      iex> update_article_favorite(article_favorite, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_article_favorite(%ArticleFavorite{} = article_favorite, attrs) do
    article_favorite
    |> ArticleFavorite.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a article_favorite.

  ## Examples

      iex> delete_article_favorite(article_favorite)
      {:ok, %ArticleFavorite{}}

      iex> delete_article_favorite(article_favorite)
      {:error, %Ecto.Changeset{}}

  """
  def delete_article_favorite(%ArticleFavorite{} = article_favorite) do
    Repo.delete(article_favorite)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking article_favorite changes.

  ## Examples

      iex> change_article_favorite(article_favorite)
      %Ecto.Changeset{data: %ArticleFavorite{}}

  """
  def change_article_favorite(%ArticleFavorite{} = article_favorite, attrs \\ %{}) do
    ArticleFavorite.changeset(article_favorite, attrs)
  end

  alias RealworldPhoenix.App.Comment

  @doc """
  Returns the list of comments.

  ## Examples

      iex> list_comments()
      [%Comment{}, ...]

  """
  def list_comments do
    Repo.all(Comment)
  end

  @doc """
  Gets a single comment.

  Raises `Ecto.NoResultsError` if the Comment does not exist.

  ## Examples

      iex> get_comment!(123)
      %Comment{}

      iex> get_comment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_comment!(id), do: Repo.get!(Comment, id)

  @doc """
  Creates a comment.

  ## Examples

      iex> create_comment(%{field: value})
      {:ok, %Comment{}}

      iex> create_comment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_comment(author, attrs \\ %{}) do
    Ecto.build_assoc(author, :comments, %Comment{})
    |> Comment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a comment.

  ## Examples

      iex> update_comment(comment, %{field: new_value})
      {:ok, %Comment{}}

      iex> update_comment(comment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_comment(%Comment{} = comment, attrs) do
    comment
    |> Comment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a comment.

  ## Examples

      iex> delete_comment(comment)
      {:ok, %Comment{}}

      iex> delete_comment(comment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_comment(%Comment{} = comment) do
    Repo.delete(comment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking comment changes.

  ## Examples

      iex> change_comment(comment)
      %Ecto.Changeset{data: %Comment{}}

  """
  def change_comment(%Comment{} = comment, attrs \\ %{}) do
    Comment.changeset(comment, attrs)
  end

  alias RealworldPhoenix.App.ArticleComment

  @doc """
  Returns the list of article_comments.

  ## Examples

      iex> list_article_comments()
      [%ArticleComment{}, ...]

  """
  def list_article_comments do
    Repo.all(ArticleComment)
  end

  @doc """
  Gets a single article_comment.

  Raises `Ecto.NoResultsError` if the Article comment does not exist.

  ## Examples

      iex> get_article_comment!(123)
      %ArticleComment{}

      iex> get_article_comment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_article_comment!(id), do: Repo.get!(ArticleComment, id)

  @doc """
  Creates a article_comment.

  ## Examples

      iex> create_article_comment(%{field: value})
      {:ok, %ArticleComment{}}

      iex> create_article_comment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_article_comment(author, article, attrs \\ %{}) do
    Repo.transaction fn ->
      create_comment(author, attrs)
      |> case do
        {:error, changeset} ->
          {:error, changeset}
        {:ok, comment} ->
          struct = Ecto.build_assoc(comment, :article_comments, %ArticleComment{})
          struct = Ecto.build_assoc(article, :article_comments, struct)
          struct
          |> ArticleComment.changeset(attrs)
          |> Repo.insert()
      end
    end
  end

  @doc """
  Updates a article_comment.

  ## Examples

      iex> update_article_comment(article_comment, %{field: new_value})
      {:ok, %ArticleComment{}}

      iex> update_article_comment(article_comment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_article_comment(%ArticleComment{} = article_comment, attrs) do
    article_comment
    |> ArticleComment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a article_comment.

  ## Examples

      iex> delete_article_comment(article_comment)
      {:ok, %ArticleComment{}}

      iex> delete_article_comment(article_comment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_article_comment(%ArticleComment{} = article_comment) do
    Repo.delete(article_comment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking article_comment changes.

  ## Examples

      iex> change_article_comment(article_comment)
      %Ecto.Changeset{data: %ArticleComment{}}

  """
  def change_article_comment(%ArticleComment{} = article_comment, attrs \\ %{}) do
    ArticleComment.changeset(article_comment, attrs)
  end

  alias RealworldPhoenix.App.Tag

  @doc """
  Returns the list of tags.

  ## Examples

      iex> list_tags()
      [%Tag{}, ...]

  """
  def list_tags do
    Repo.all(Tag)
  end

  @doc """
  Gets a single tag.

  Raises `Ecto.NoResultsError` if the Tag does not exist.

  ## Examples

      iex> get_tag!(123)
      %Tag{}

      iex> get_tag!(456)
      ** (Ecto.NoResultsError)

  """
  def get_tag!(id), do: Repo.get!(Tag, id)

  @doc """
  Creates a tag.

  ## Examples

      iex> create_tag(%{field: value})
      {:ok, %Tag{}}

      iex> create_tag(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_tag(attrs \\ %{}) do
    %Tag{}
    |> Tag.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a tag.

  ## Examples

      iex> update_tag(tag, %{field: new_value})
      {:ok, %Tag{}}

      iex> update_tag(tag, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_tag(%Tag{} = tag, attrs) do
    tag
    |> Tag.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a tag.

  ## Examples

      iex> delete_tag(tag)
      {:ok, %Tag{}}

      iex> delete_tag(tag)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tag(%Tag{} = tag) do
    Repo.delete(tag)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tag changes.

  ## Examples

      iex> change_tag(tag)
      %Ecto.Changeset{data: %Tag{}}

  """
  def change_tag(%Tag{} = tag, attrs \\ %{}) do
    Tag.changeset(tag, attrs)
  end

  alias RealworldPhoenix.App.ArticleTag

  @doc """
  Returns the list of article_tags.

  ## Examples

      iex> list_article_tags()
      [%ArticleTag{}, ...]

  """
  def list_article_tags do
    Repo.all(ArticleTag)
  end

  @doc """
  Gets a single article_tag.

  Raises `Ecto.NoResultsError` if the Article tag does not exist.

  ## Examples

      iex> get_article_tag!(123)
      %ArticleTag{}

      iex> get_article_tag!(456)
      ** (Ecto.NoResultsError)

  """
  def get_article_tag!(id), do: Repo.get!(ArticleTag, id)

  @doc """
  Creates a article_tag.

  ## Examples

      iex> create_article_tag(%{field: value})
      {:ok, %ArticleTag{}}

      iex> create_article_tag(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_article_tag(attrs \\ %{}) do
    %ArticleTag{}
    |> ArticleTag.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a article_tag.

  ## Examples

      iex> update_article_tag(article_tag, %{field: new_value})
      {:ok, %ArticleTag{}}

      iex> update_article_tag(article_tag, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_article_tag(%ArticleTag{} = article_tag, attrs) do
    article_tag
    |> ArticleTag.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a article_tag.

  ## Examples

      iex> delete_article_tag(article_tag)
      {:ok, %ArticleTag{}}

      iex> delete_article_tag(article_tag)
      {:error, %Ecto.Changeset{}}

  """
  def delete_article_tag(%ArticleTag{} = article_tag) do
    Repo.delete(article_tag)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking article_tag changes.

  ## Examples

      iex> change_article_tag(article_tag)
      %Ecto.Changeset{data: %ArticleTag{}}

  """
  def change_article_tag(%ArticleTag{} = article_tag, attrs \\ %{}) do
    ArticleTag.changeset(article_tag, attrs)
  end

  @doc """
  Returns the list of profile_followers.

  ## Examples

      iex> list_profile_followers()
      [%ProfileFollower{}, ...]

  """
  def list_profile_followers do
    Repo.all(ProfileFollower)
  end

  @doc """
  Gets a single profile_followers.

  Raises `Ecto.NoResultsError` if the Profile followers does not exist.

  ## Examples

      iex> get_profile_followers!(123)
      %ProfileFollower{}

      iex> get_profile_followers!(456)
      ** (Ecto.NoResultsError)

  """
  def get_profile_follower!(id), do: Repo.get!(ProfileFollower, id)

  @doc """
  Creates a profile_followers.

  ## Examples

      iex> create_profile_followers(%{field: value})
      {:ok, %ProfileFollower{}}

      iex> create_profile_followers(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_profile_follower(following, follower, attrs \\ %{}) do
    struct = Ecto.build_assoc(follower, :profile_following, %ProfileFollower{})
    struct = Ecto.build_assoc(following, :profile_followers, struct)
    struct
    |> ProfileFollower.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a profile_followers.

  ## Examples

      iex> update_profile_followers(profile_followers, %{field: new_value})
      {:ok, %ProfileFollower{}}

      iex> update_profile_followers(profile_followers, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_profile_follower(%ProfileFollower{} = profile_follower, attrs) do
    profile_follower
    |> ProfileFollower.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a profile_followers.

  ## Examples

      iex> delete_profile_followers(profile_followers)
      {:ok, %ProfileFollower{}}

      iex> delete_profile_followers(profile_followers)
      {:error, %Ecto.Changeset{}}

  """
  def delete_profile_follower(%ProfileFollower{} = profile_followers) do
    Repo.delete(profile_followers)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking profile_followers changes.

  ## Examples

      iex> change_profile_followers(profile_followers)
      %Ecto.Changeset{data: %ProfileFollower{}}

  """
  def change_profile_follower(%ProfileFollower{} = profile_followers, attrs \\ %{}) do
    ProfileFollower.changeset(profile_followers, attrs)
  end
end
