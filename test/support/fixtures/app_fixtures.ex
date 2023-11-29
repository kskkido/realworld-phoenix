defmodule RealworldPhoenix.AppFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `RealworldPhoenix.App` context.
  """

  @doc """
  Generate a profile.
  """
  def profile_fixture(attrs \\ %{}) do
    {:ok, profile} =
      attrs
      |> Enum.into(%{
        bio: "some bio",
        image: "some image",
        username: "some username"
      })
      |> RealworldPhoenix.App.create_profile()

    profile
  end

  @doc """
  Generate a article.
  """
  def article_fixture(attrs \\ %{}) do
    {:ok, article} =
      attrs
      |> Enum.into(%{
        body: "some body",
        created_at: ~T[14:00:00],
        description: "some description",
        slug: "some slug",
        title: "some title",
        updated_at: ~T[14:00:00]
      })
      |> RealworldPhoenix.App.create_article()

    article
  end

  @doc """
  Generate a article_favorite.
  """
  def article_favorite_fixture(attrs \\ %{}) do
    {:ok, article_favorite} =
      attrs
      |> Enum.into(%{

      })
      |> RealworldPhoenix.App.create_article_favorite()

    article_favorite
  end

  @doc """
  Generate a comment.
  """
  def comment_fixture(attrs \\ %{}) do
    {:ok, comment} =
      attrs
      |> Enum.into(%{
        body: "some body"
      })
      |> RealworldPhoenix.App.create_comment()

    comment
  end

  @doc """
  Generate a article_comment.
  """
  def article_comment_fixture(attrs \\ %{}) do
    {:ok, article_comment} =
      attrs
      |> Enum.into(%{

      })
      |> RealworldPhoenix.App.create_article_comment()

    article_comment
  end

  @doc """
  Generate a tag.
  """
  def tag_fixture(attrs \\ %{}) do
    {:ok, tag} =
      attrs
      |> Enum.into(%{
        label: "some label"
      })
      |> RealworldPhoenix.App.create_tag()

    tag
  end

  @doc """
  Generate a article_tag.
  """
  def article_tag_fixture(attrs \\ %{}) do
    {:ok, article_tag} =
      attrs
      |> Enum.into(%{

      })
      |> RealworldPhoenix.App.create_article_tag()

    article_tag
  end

  @doc """
  Generate a profile_followers.
  """
  def profile_followers_fixture(attrs \\ %{}) do
    {:ok, profile_followers} =
      attrs
      |> Enum.into(%{

      })
      |> RealworldPhoenix.App.create_profile_followers()

    profile_followers
  end
end
