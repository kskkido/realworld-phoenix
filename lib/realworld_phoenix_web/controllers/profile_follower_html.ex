defmodule RealworldPhoenixWeb.ProfileFollowerHTML do
  use RealworldPhoenixWeb, :html

  embed_templates "profile_follower_html/*"

  @doc """
  Renders a profile_followers form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def profile_follower_form(assigns)
end
