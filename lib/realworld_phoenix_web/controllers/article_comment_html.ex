defmodule RealworldPhoenixWeb.ArticleCommentHTML do
  use RealworldPhoenixWeb, :html

  embed_templates "article_comment_html/*"

  @doc """
  Renders a article_comment form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def article_comment_form(assigns)
end
