defmodule RealworldPhoenixWeb.ArticleFavoriteController do
  use RealworldPhoenixWeb, :controller

  alias RealworldPhoenix.App
  alias RealworldPhoenix.App.ArticleFavorite

  def index(conn, _params) do
    article_favorites = App.list_article_favorites()
    render(conn, :index, article_favorites: article_favorites)
  end

  def new(conn, _params) do
    changeset = App.change_article_favorite(%ArticleFavorite{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"article_favorite" => article_favorite_params}) do
    case App.create_article_favorite(article_favorite_params) do
      {:ok, article_favorite} ->
        conn
        |> put_flash(:info, "Article favorite created successfully.")
        |> redirect(to: ~p"/article_favorites/#{article_favorite}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    article_favorite = App.get_article_favorite!(id)
    render(conn, :show, article_favorite: article_favorite)
  end

  def edit(conn, %{"id" => id}) do
    article_favorite = App.get_article_favorite!(id)
    changeset = App.change_article_favorite(article_favorite)
    render(conn, :edit, article_favorite: article_favorite, changeset: changeset)
  end

  def update(conn, %{"id" => id, "article_favorite" => article_favorite_params}) do
    article_favorite = App.get_article_favorite!(id)

    case App.update_article_favorite(article_favorite, article_favorite_params) do
      {:ok, article_favorite} ->
        conn
        |> put_flash(:info, "Article favorite updated successfully.")
        |> redirect(to: ~p"/article_favorites/#{article_favorite}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, article_favorite: article_favorite, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    article_favorite = App.get_article_favorite!(id)
    {:ok, _article_favorite} = App.delete_article_favorite(article_favorite)

    conn
    |> put_flash(:info, "Article favorite deleted successfully.")
    |> redirect(to: ~p"/article_favorites")
  end
end
