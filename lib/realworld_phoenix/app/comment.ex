defmodule RealworldPhoenix.App.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :body, :string
    belongs_to :author, RealworldPhoenix.App.Profile

    has_many(
      :article_comments,
      RealworldPhoenix.App.ArticleComment,
      foreign_key: :comment_id
    )

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:body])
    |> validate_required([:body])
  end
end
