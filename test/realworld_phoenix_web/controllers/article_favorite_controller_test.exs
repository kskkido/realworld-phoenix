defmodule RealworldPhoenixWeb.ArticleFavoriteControllerTest do
  use RealworldPhoenixWeb.ConnCase

  import RealworldPhoenix.AppFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  describe "index" do
    test "lists all article_favorites", %{conn: conn} do
      conn = get(conn, ~p"/article_favorites")
      assert html_response(conn, 200) =~ "Listing Article favorites"
    end
  end

  describe "new article_favorite" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/article_favorites/new")
      assert html_response(conn, 200) =~ "New Article favorite"
    end
  end

  describe "create article_favorite" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/article_favorites", article_favorite: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/article_favorites/#{id}"

      conn = get(conn, ~p"/article_favorites/#{id}")
      assert html_response(conn, 200) =~ "Article favorite #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/article_favorites", article_favorite: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Article favorite"
    end
  end

  describe "edit article_favorite" do
    setup [:create_article_favorite]

    test "renders form for editing chosen article_favorite", %{conn: conn, article_favorite: article_favorite} do
      conn = get(conn, ~p"/article_favorites/#{article_favorite}/edit")
      assert html_response(conn, 200) =~ "Edit Article favorite"
    end
  end

  describe "update article_favorite" do
    setup [:create_article_favorite]

    test "redirects when data is valid", %{conn: conn, article_favorite: article_favorite} do
      conn = put(conn, ~p"/article_favorites/#{article_favorite}", article_favorite: @update_attrs)
      assert redirected_to(conn) == ~p"/article_favorites/#{article_favorite}"

      conn = get(conn, ~p"/article_favorites/#{article_favorite}")
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, article_favorite: article_favorite} do
      conn = put(conn, ~p"/article_favorites/#{article_favorite}", article_favorite: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Article favorite"
    end
  end

  describe "delete article_favorite" do
    setup [:create_article_favorite]

    test "deletes chosen article_favorite", %{conn: conn, article_favorite: article_favorite} do
      conn = delete(conn, ~p"/article_favorites/#{article_favorite}")
      assert redirected_to(conn) == ~p"/article_favorites"

      assert_error_sent 404, fn ->
        get(conn, ~p"/article_favorites/#{article_favorite}")
      end
    end
  end

  defp create_article_favorite(_) do
    article_favorite = article_favorite_fixture()
    %{article_favorite: article_favorite}
  end
end
