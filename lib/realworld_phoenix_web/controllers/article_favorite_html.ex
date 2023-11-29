defmodule RealworldPhoenixWeb.ArticleFavoriteHTML do
  use RealworldPhoenixWeb, :html

  embed_templates "article_favorite_html/*"

  @doc """
  Renders a article_favorite form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def article_favorite_form(assigns)
end
