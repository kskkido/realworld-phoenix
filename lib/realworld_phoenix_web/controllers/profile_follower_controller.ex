defmodule RealworldPhoenixWeb.ProfileFollowerController do
  use RealworldPhoenixWeb, :controller

  alias RealworldPhoenix.App
  alias RealworldPhoenix.App.ProfileFollower

  def index(conn, _params) do
    profile_followers = App.list_profile_followers()
    render(conn, :index, profile_follower_collection: profile_followers)
  end

  def new(conn, _params) do
    changeset = App.change_profile_follower(%ProfileFollower{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"profile_follower" => profile_follower_params}) do
    case App.create_profile_follower(profile_follower_params) do
      {:ok, profile_follower} ->
        conn
        |> put_flash(:info, "Profile followers created successfully.")
        |> redirect(to: ~p"/profile_followers/#{profile_follower}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    profile_follower = App.get_profile_follower!(id)
    render(conn, :show, profile_follower: profile_follower)
  end

  def edit(conn, %{"id" => id}) do
    profile_follower = App.get_profile_follower!(id)
    changeset = App.change_profile_follower(profile_follower)
    render(conn, :edit, profile_follower: profile_follower, changeset: changeset)
  end

  def update(conn, %{"id" => id, "profile_follower" => profile_follower_params}) do
    profile_follower = App.get_profile_follower!(id)

    case App.update_profile_follower(profile_follower, profile_follower_params) do
      {:ok, profile_follower} ->
        conn
        |> put_flash(:info, "Profile followers updated successfully.")
        |> redirect(to: ~p"/profile_followers/#{profile_follower}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, profile_follower: profile_follower, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    profile_follower = App.get_profile_follower!(id)
    {:ok, _profile_follower} = App.delete_profile_follower(profile_follower)

    conn
    |> put_flash(:info, "Profile followers deleted successfully.")
    |> redirect(to: ~p"/profile_followers")
  end
end
