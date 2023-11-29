defmodule RealworldPhoenixWeb.ArticleCommentController do
  use RealworldPhoenixWeb, :controller

  alias RealworldPhoenix.App
  alias RealworldPhoenix.App.ArticleComment

  def index(conn, _params) do
    article_comments = App.list_article_comments()
    render(conn, :index, article_comments: article_comments)
  end

  def new(conn, _params) do
    changeset = App.change_article_comment(%ArticleComment{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"article_comment" => article_comment_params}) do
    case App.create_article_comment(article_comment_params) do
      {:ok, article_comment} ->
        conn
        |> put_flash(:info, "Article comment created successfully.")
        |> redirect(to: ~p"/article_comments/#{article_comment}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    article_comment = App.get_article_comment!(id)
    render(conn, :show, article_comment: article_comment)
  end

  def edit(conn, %{"id" => id}) do
    article_comment = App.get_article_comment!(id)
    changeset = App.change_article_comment(article_comment)
    render(conn, :edit, article_comment: article_comment, changeset: changeset)
  end

  def update(conn, %{"id" => id, "article_comment" => article_comment_params}) do
    article_comment = App.get_article_comment!(id)

    case App.update_article_comment(article_comment, article_comment_params) do
      {:ok, article_comment} ->
        conn
        |> put_flash(:info, "Article comment updated successfully.")
        |> redirect(to: ~p"/article_comments/#{article_comment}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, article_comment: article_comment, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    article_comment = App.get_article_comment!(id)
    {:ok, _article_comment} = App.delete_article_comment(article_comment)

    conn
    |> put_flash(:info, "Article comment deleted successfully.")
    |> redirect(to: ~p"/article_comments")
  end
end
