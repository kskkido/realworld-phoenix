defmodule RealworldPhoenix.App.ProfileFollower do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "profile_followers" do
    belongs_to(
      :follower,
      RealworldPhoenix.App.Profile,
      primary_key: true,
      foreign_key: :follower_id
    )
    belongs_to(
      :following,
      RealworldPhoenix.App.Profile,
      primary_key: true,
      foreign_key: :following_id
    )

    timestamps()
  end

  @doc false
  def changeset(profile_followers, attrs) do
    profile_followers
    |> cast(attrs, [])
    |> validate_required([])
  end
end
