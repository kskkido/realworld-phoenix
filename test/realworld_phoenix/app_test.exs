defmodule RealworldPhoenix.AppTest do
  use RealworldPhoenix.DataCase

  alias RealworldPhoenix.App

  describe "profiles" do
    alias RealworldPhoenix.App.Profile

    import RealworldPhoenix.AppFixtures

    @invalid_attrs %{bio: nil, image: nil, username: nil}

    test "list_profiles/0 returns all profiles" do
      profile = profile_fixture()
      assert App.list_profiles() == [profile]
    end

    test "get_profile!/1 returns the profile with given id" do
      profile = profile_fixture()
      assert App.get_profile!(profile.id) == profile
    end

    test "create_profile/1 with valid data creates a profile" do
      valid_attrs = %{bio: "some bio", image: "some image", username: "some username"}

      assert {:ok, %Profile{} = profile} = App.create_profile(valid_attrs)
      assert profile.bio == "some bio"
      assert profile.image == "some image"
      assert profile.username == "some username"
    end

    test "create_profile/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = App.create_profile(@invalid_attrs)
    end

    test "update_profile/2 with valid data updates the profile" do
      profile = profile_fixture()
      update_attrs = %{bio: "some updated bio", image: "some updated image", username: "some updated username"}

      assert {:ok, %Profile{} = profile} = App.update_profile(profile, update_attrs)
      assert profile.bio == "some updated bio"
      assert profile.image == "some updated image"
      assert profile.username == "some updated username"
    end

    test "update_profile/2 with invalid data returns error changeset" do
      profile = profile_fixture()
      assert {:error, %Ecto.Changeset{}} = App.update_profile(profile, @invalid_attrs)
      assert profile == App.get_profile!(profile.id)
    end

    test "delete_profile/1 deletes the profile" do
      profile = profile_fixture()
      assert {:ok, %Profile{}} = App.delete_profile(profile)
      assert_raise Ecto.NoResultsError, fn -> App.get_profile!(profile.id) end
    end

    test "change_profile/1 returns a profile changeset" do
      profile = profile_fixture()
      assert %Ecto.Changeset{} = App.change_profile(profile)
    end
  end

  describe "articles" do
    alias RealworldPhoenix.App.Article

    import RealworldPhoenix.AppFixtures

    @invalid_attrs %{body: nil, created_at: nil, description: nil, slug: nil, title: nil, updated_at: nil}

    test "list_articles/0 returns all articles" do
      article = article_fixture()
      assert App.list_articles() == [article]
    end

    test "get_article!/1 returns the article with given id" do
      article = article_fixture()
      assert App.get_article!(article.id) == article
    end

    test "create_article/1 with valid data creates a article" do
      valid_attrs = %{body: "some body", created_at: ~T[14:00:00], description: "some description", slug: "some slug", title: "some title", updated_at: ~T[14:00:00]}

      assert {:ok, %Article{} = article} = App.create_article(valid_attrs)
      assert article.body == "some body"
      assert article.created_at == ~T[14:00:00]
      assert article.description == "some description"
      assert article.slug == "some slug"
      assert article.title == "some title"
      assert article.updated_at == ~T[14:00:00]
    end

    test "create_article/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = App.create_article(@invalid_attrs)
    end

    test "update_article/2 with valid data updates the article" do
      article = article_fixture()
      update_attrs = %{body: "some updated body", created_at: ~T[15:01:01], description: "some updated description", slug: "some updated slug", title: "some updated title", updated_at: ~T[15:01:01]}

      assert {:ok, %Article{} = article} = App.update_article(article, update_attrs)
      assert article.body == "some updated body"
      assert article.created_at == ~T[15:01:01]
      assert article.description == "some updated description"
      assert article.slug == "some updated slug"
      assert article.title == "some updated title"
      assert article.updated_at == ~T[15:01:01]
    end

    test "update_article/2 with invalid data returns error changeset" do
      article = article_fixture()
      assert {:error, %Ecto.Changeset{}} = App.update_article(article, @invalid_attrs)
      assert article == App.get_article!(article.id)
    end

    test "delete_article/1 deletes the article" do
      article = article_fixture()
      assert {:ok, %Article{}} = App.delete_article(article)
      assert_raise Ecto.NoResultsError, fn -> App.get_article!(article.id) end
    end

    test "change_article/1 returns a article changeset" do
      article = article_fixture()
      assert %Ecto.Changeset{} = App.change_article(article)
    end
  end

  describe "article_favorites" do
    alias RealworldPhoenix.App.ArticleFavorite

    import RealworldPhoenix.AppFixtures

    @invalid_attrs %{}

    test "list_article_favorites/0 returns all article_favorites" do
      article_favorite = article_favorite_fixture()
      assert App.list_article_favorites() == [article_favorite]
    end

    test "get_article_favorite!/1 returns the article_favorite with given id" do
      article_favorite = article_favorite_fixture()
      assert App.get_article_favorite!(article_favorite.id) == article_favorite
    end

    test "create_article_favorite/1 with valid data creates a article_favorite" do
      valid_attrs = %{}

      assert {:ok, %ArticleFavorite{} = article_favorite} = App.create_article_favorite(valid_attrs)
    end

    test "create_article_favorite/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = App.create_article_favorite(@invalid_attrs)
    end

    test "update_article_favorite/2 with valid data updates the article_favorite" do
      article_favorite = article_favorite_fixture()
      update_attrs = %{}

      assert {:ok, %ArticleFavorite{} = article_favorite} = App.update_article_favorite(article_favorite, update_attrs)
    end

    test "update_article_favorite/2 with invalid data returns error changeset" do
      article_favorite = article_favorite_fixture()
      assert {:error, %Ecto.Changeset{}} = App.update_article_favorite(article_favorite, @invalid_attrs)
      assert article_favorite == App.get_article_favorite!(article_favorite.id)
    end

    test "delete_article_favorite/1 deletes the article_favorite" do
      article_favorite = article_favorite_fixture()
      assert {:ok, %ArticleFavorite{}} = App.delete_article_favorite(article_favorite)
      assert_raise Ecto.NoResultsError, fn -> App.get_article_favorite!(article_favorite.id) end
    end

    test "change_article_favorite/1 returns a article_favorite changeset" do
      article_favorite = article_favorite_fixture()
      assert %Ecto.Changeset{} = App.change_article_favorite(article_favorite)
    end
  end

  describe "comments" do
    alias RealworldPhoenix.App.Comment

    import RealworldPhoenix.AppFixtures

    @invalid_attrs %{body: nil}

    test "list_comments/0 returns all comments" do
      comment = comment_fixture()
      assert App.list_comments() == [comment]
    end

    test "get_comment!/1 returns the comment with given id" do
      comment = comment_fixture()
      assert App.get_comment!(comment.id) == comment
    end

    test "create_comment/1 with valid data creates a comment" do
      valid_attrs = %{body: "some body"}

      assert {:ok, %Comment{} = comment} = App.create_comment(valid_attrs)
      assert comment.body == "some body"
    end

    test "create_comment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = App.create_comment(@invalid_attrs)
    end

    test "update_comment/2 with valid data updates the comment" do
      comment = comment_fixture()
      update_attrs = %{body: "some updated body"}

      assert {:ok, %Comment{} = comment} = App.update_comment(comment, update_attrs)
      assert comment.body == "some updated body"
    end

    test "update_comment/2 with invalid data returns error changeset" do
      comment = comment_fixture()
      assert {:error, %Ecto.Changeset{}} = App.update_comment(comment, @invalid_attrs)
      assert comment == App.get_comment!(comment.id)
    end

    test "delete_comment/1 deletes the comment" do
      comment = comment_fixture()
      assert {:ok, %Comment{}} = App.delete_comment(comment)
      assert_raise Ecto.NoResultsError, fn -> App.get_comment!(comment.id) end
    end

    test "change_comment/1 returns a comment changeset" do
      comment = comment_fixture()
      assert %Ecto.Changeset{} = App.change_comment(comment)
    end
  end

  describe "article_comments" do
    alias RealworldPhoenix.App.ArticleComment

    import RealworldPhoenix.AppFixtures

    @invalid_attrs %{}

    test "list_article_comments/0 returns all article_comments" do
      article_comment = article_comment_fixture()
      assert App.list_article_comments() == [article_comment]
    end

    test "get_article_comment!/1 returns the article_comment with given id" do
      article_comment = article_comment_fixture()
      assert App.get_article_comment!(article_comment.id) == article_comment
    end

    test "create_article_comment/1 with valid data creates a article_comment" do
      valid_attrs = %{}

      assert {:ok, %ArticleComment{} = article_comment} = App.create_article_comment(valid_attrs)
    end

    test "create_article_comment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = App.create_article_comment(@invalid_attrs)
    end

    test "update_article_comment/2 with valid data updates the article_comment" do
      article_comment = article_comment_fixture()
      update_attrs = %{}

      assert {:ok, %ArticleComment{} = article_comment} = App.update_article_comment(article_comment, update_attrs)
    end

    test "update_article_comment/2 with invalid data returns error changeset" do
      article_comment = article_comment_fixture()
      assert {:error, %Ecto.Changeset{}} = App.update_article_comment(article_comment, @invalid_attrs)
      assert article_comment == App.get_article_comment!(article_comment.id)
    end

    test "delete_article_comment/1 deletes the article_comment" do
      article_comment = article_comment_fixture()
      assert {:ok, %ArticleComment{}} = App.delete_article_comment(article_comment)
      assert_raise Ecto.NoResultsError, fn -> App.get_article_comment!(article_comment.id) end
    end

    test "change_article_comment/1 returns a article_comment changeset" do
      article_comment = article_comment_fixture()
      assert %Ecto.Changeset{} = App.change_article_comment(article_comment)
    end
  end

  describe "tags" do
    alias RealworldPhoenix.App.Tag

    import RealworldPhoenix.AppFixtures

    @invalid_attrs %{label: nil}

    test "list_tags/0 returns all tags" do
      tag = tag_fixture()
      assert App.list_tags() == [tag]
    end

    test "get_tag!/1 returns the tag with given id" do
      tag = tag_fixture()
      assert App.get_tag!(tag.id) == tag
    end

    test "create_tag/1 with valid data creates a tag" do
      valid_attrs = %{label: "some label"}

      assert {:ok, %Tag{} = tag} = App.create_tag(valid_attrs)
      assert tag.label == "some label"
    end

    test "create_tag/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = App.create_tag(@invalid_attrs)
    end

    test "update_tag/2 with valid data updates the tag" do
      tag = tag_fixture()
      update_attrs = %{label: "some updated label"}

      assert {:ok, %Tag{} = tag} = App.update_tag(tag, update_attrs)
      assert tag.label == "some updated label"
    end

    test "update_tag/2 with invalid data returns error changeset" do
      tag = tag_fixture()
      assert {:error, %Ecto.Changeset{}} = App.update_tag(tag, @invalid_attrs)
      assert tag == App.get_tag!(tag.id)
    end

    test "delete_tag/1 deletes the tag" do
      tag = tag_fixture()
      assert {:ok, %Tag{}} = App.delete_tag(tag)
      assert_raise Ecto.NoResultsError, fn -> App.get_tag!(tag.id) end
    end

    test "change_tag/1 returns a tag changeset" do
      tag = tag_fixture()
      assert %Ecto.Changeset{} = App.change_tag(tag)
    end
  end

  describe "article_tags" do
    alias RealworldPhoenix.App.ArticleTag

    import RealworldPhoenix.AppFixtures

    @invalid_attrs %{}

    test "list_article_tags/0 returns all article_tags" do
      article_tag = article_tag_fixture()
      assert App.list_article_tags() == [article_tag]
    end

    test "get_article_tag!/1 returns the article_tag with given id" do
      article_tag = article_tag_fixture()
      assert App.get_article_tag!(article_tag.id) == article_tag
    end

    test "create_article_tag/1 with valid data creates a article_tag" do
      valid_attrs = %{}

      assert {:ok, %ArticleTag{} = article_tag} = App.create_article_tag(valid_attrs)
    end

    test "create_article_tag/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = App.create_article_tag(@invalid_attrs)
    end

    test "update_article_tag/2 with valid data updates the article_tag" do
      article_tag = article_tag_fixture()
      update_attrs = %{}

      assert {:ok, %ArticleTag{} = article_tag} = App.update_article_tag(article_tag, update_attrs)
    end

    test "update_article_tag/2 with invalid data returns error changeset" do
      article_tag = article_tag_fixture()
      assert {:error, %Ecto.Changeset{}} = App.update_article_tag(article_tag, @invalid_attrs)
      assert article_tag == App.get_article_tag!(article_tag.id)
    end

    test "delete_article_tag/1 deletes the article_tag" do
      article_tag = article_tag_fixture()
      assert {:ok, %ArticleTag{}} = App.delete_article_tag(article_tag)
      assert_raise Ecto.NoResultsError, fn -> App.get_article_tag!(article_tag.id) end
    end

    test "change_article_tag/1 returns a article_tag changeset" do
      article_tag = article_tag_fixture()
      assert %Ecto.Changeset{} = App.change_article_tag(article_tag)
    end
  end

  describe "profile_followers" do
    alias RealworldPhoenix.App.ProfileFollowers

    import RealworldPhoenix.AppFixtures

    @invalid_attrs %{}

    test "list_profile_followers/0 returns all profile_followers" do
      profile_followers = profile_followers_fixture()
      assert App.list_profile_followers() == [profile_followers]
    end

    test "get_profile_followers!/1 returns the profile_followers with given id" do
      profile_followers = profile_followers_fixture()
      assert App.get_profile_followers!(profile_followers.id) == profile_followers
    end

    test "create_profile_followers/1 with valid data creates a profile_followers" do
      valid_attrs = %{}

      assert {:ok, %ProfileFollowers{} = profile_followers} = App.create_profile_followers(valid_attrs)
    end

    test "create_profile_followers/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = App.create_profile_followers(@invalid_attrs)
    end

    test "update_profile_followers/2 with valid data updates the profile_followers" do
      profile_followers = profile_followers_fixture()
      update_attrs = %{}

      assert {:ok, %ProfileFollowers{} = profile_followers} = App.update_profile_followers(profile_followers, update_attrs)
    end

    test "update_profile_followers/2 with invalid data returns error changeset" do
      profile_followers = profile_followers_fixture()
      assert {:error, %Ecto.Changeset{}} = App.update_profile_followers(profile_followers, @invalid_attrs)
      assert profile_followers == App.get_profile_followers!(profile_followers.id)
    end

    test "delete_profile_followers/1 deletes the profile_followers" do
      profile_followers = profile_followers_fixture()
      assert {:ok, %ProfileFollowers{}} = App.delete_profile_followers(profile_followers)
      assert_raise Ecto.NoResultsError, fn -> App.get_profile_followers!(profile_followers.id) end
    end

    test "change_profile_followers/1 returns a profile_followers changeset" do
      profile_followers = profile_followers_fixture()
      assert %Ecto.Changeset{} = App.change_profile_followers(profile_followers)
    end
  end
end
