defmodule RealworldPhoenixWeb.ProfileHTML do
  use RealworldPhoenixWeb, :html

  embed_templates "profile_html/*"

  @doc """
  Renders a profile form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def profile_form(assigns)
end
