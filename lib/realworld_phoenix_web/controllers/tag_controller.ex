defmodule RealworldPhoenixWeb.TagController do
  use RealworldPhoenixWeb, :controller

  alias RealworldPhoenix.App
  alias RealworldPhoenix.App.Tag

  def index(conn, _params) do
    tags = App.list_tags()
    render(conn, :index, tags: tags)
  end

  def new(conn, _params) do
    changeset = App.change_tag(%Tag{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"tag" => tag_params}) do
    case App.create_tag(tag_params) do
      {:ok, tag} ->
        conn
        |> put_flash(:info, "Tag created successfully.")
        |> redirect(to: ~p"/tags/#{tag}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    tag = App.get_tag!(id)
    render(conn, :show, tag: tag)
  end

  def edit(conn, %{"id" => id}) do
    tag = App.get_tag!(id)
    changeset = App.change_tag(tag)
    render(conn, :edit, tag: tag, changeset: changeset)
  end

  def update(conn, %{"id" => id, "tag" => tag_params}) do
    tag = App.get_tag!(id)

    case App.update_tag(tag, tag_params) do
      {:ok, tag} ->
        conn
        |> put_flash(:info, "Tag updated successfully.")
        |> redirect(to: ~p"/tags/#{tag}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, tag: tag, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    tag = App.get_tag!(id)
    {:ok, _tag} = App.delete_tag(tag)

    conn
    |> put_flash(:info, "Tag deleted successfully.")
    |> redirect(to: ~p"/tags")
  end
end
