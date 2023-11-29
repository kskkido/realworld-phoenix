defmodule RealworldPhoenix.Repo.Migrations.CreateProfileFollowers do
  use Ecto.Migration

  def change do
    create table(:profile_followers, primary_key: false) do
      add :follower_id, references(:profiles, on_delete: :nothing), primary_key: true
      add :following_id, references(:profiles, on_delete: :nothing), primary_key: true

      timestamps()
    end

    create index(:profile_followers, [:follower_id])
    create index(:profile_followers, [:following_id])
  end
end
