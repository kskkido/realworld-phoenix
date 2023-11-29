defmodule RealworldPhoenixWeb.AppController do
  use RealworldPhoenixWeb, :controller

  alias RealworldPhoenix.App

  def home(conn, _params) do
    articles = App.list_articles()
    render(conn, :home, articles: articles)
  end
end
