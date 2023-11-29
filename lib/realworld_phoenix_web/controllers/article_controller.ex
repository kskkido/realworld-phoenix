defmodule RealworldPhoenixWeb.ArticleController do
  use RealworldPhoenixWeb, :controller

  alias RealworldPhoenix.App
  alias RealworldPhoenix.App.Article

  def index(conn, _params) do
    articles = App.list_articles_feed()
    render(conn, :index, articles: articles)
  end

  def new(conn, _params) do
    changeset = App.change_article(%Article{})
    render(conn, :new, changeset: changeset)
  end

  def show(conn, %{"id" => id}) do
    article = App.get_article!(id)
    render(conn, :show, article: article)
  end

  def edit(conn, %{"id" => id}) do
    article = App.get_article!(id)
    changeset = App.change_article(article)
    render(conn, :edit, article: article, changeset: changeset)
  end

  def create(%{assigns: %{current_user: user} } = conn, %{"article" => article_params}) do
    profile = App.get_profile_by_user!(user)
    case App.create_article(profile, article_params) do
      {:ok, article} ->
        conn
        |> put_flash(:info, "Article created successfully.")
        |> redirect(to: ~p"/articles/#{article.slug}")
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def update(%{assigns: %{current_user: user} } = conn, %{"id" => id, "article" => article_params}) do
    profile = App.get_profile_by_user!(user)
    article = App.get_article_by!(id: id)
    cond do
      profile.id == article.author.id ->
        case App.update_article(article, article_params) do
          {:ok, article} ->
            conn
            |> put_flash(:info, "Article updated successfully.")
            |> redirect(to: ~p"/articles/#{article.slug}")
          {:error, %Ecto.Changeset{} = changeset} ->
            conn
            |> render(:edit, article: article, changeset: changeset)
        end
      true ->
        conn
        |> redirect(to: ~p"/login")
        |> halt()
    end
  end

  def delete(conn, %{"id" => id}) do
    article = App.get_article!(id)
    {:ok, _article} = App.delete_article(article)

    conn
    |> put_flash(:info, "Article deleted successfully.")
    |> redirect(to: ~p"/articles")
  end

  def create_favorite(%{assigns: %{current_user: user} } = conn, %{"id" => id}) do
    article = App.get_article!(id)
    case App.create_article_favorite(user.profile, article) do
      {:ok, _article_favorite} ->
        conn
        |> put_flash(:info, "Article favorited successfully.")
        |> redirect(to: ~p"/")
      {:error, %Ecto.Changeset{} = _changeset} ->
        conn
        |> put_flash(:info, "Unable to favorite article.")
        |> redirect(to: ~p"/")
    end
  end
  def create_favorite(conn, _params) do
    conn
    |> redirect(to: ~p"/login")
    |> halt()
  end
end
