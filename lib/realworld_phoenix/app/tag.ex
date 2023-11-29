defmodule RealworldPhoenix.App.Tag do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tags" do
    field :label, :string
    timestamps()

    many_to_many(
      :articles,
      RealworldPhoenix.App.Article,
      join_through: RealworldPhoenix.App.ArticleTag
    )
  end

  @doc false
  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:label])
    |> validate_required([:label])
  end
end
