defmodule RealworldPhoenixWeb.TagHTML do
  use RealworldPhoenixWeb, :html

  embed_templates "tag_html/*"

  @doc """
  Renders a tag form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def tag_form(assigns)
end
