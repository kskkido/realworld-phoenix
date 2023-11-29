defmodule RealworldPhoenixWeb.ArticleCommentControllerTest do
  use RealworldPhoenixWeb.ConnCase

  import RealworldPhoenix.AppFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  describe "index" do
    test "lists all article_comments", %{conn: conn} do
      conn = get(conn, ~p"/article_comments")
      assert html_response(conn, 200) =~ "Listing Article comments"
    end
  end

  describe "new article_comment" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/article_comments/new")
      assert html_response(conn, 200) =~ "New Article comment"
    end
  end

  describe "create article_comment" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/article_comments", article_comment: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/article_comments/#{id}"

      conn = get(conn, ~p"/article_comments/#{id}")
      assert html_response(conn, 200) =~ "Article comment #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/article_comments", article_comment: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Article comment"
    end
  end

  describe "edit article_comment" do
    setup [:create_article_comment]

    test "renders form for editing chosen article_comment", %{conn: conn, article_comment: article_comment} do
      conn = get(conn, ~p"/article_comments/#{article_comment}/edit")
      assert html_response(conn, 200) =~ "Edit Article comment"
    end
  end

  describe "update article_comment" do
    setup [:create_article_comment]

    test "redirects when data is valid", %{conn: conn, article_comment: article_comment} do
      conn = put(conn, ~p"/article_comments/#{article_comment}", article_comment: @update_attrs)
      assert redirected_to(conn) == ~p"/article_comments/#{article_comment}"

      conn = get(conn, ~p"/article_comments/#{article_comment}")
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, article_comment: article_comment} do
      conn = put(conn, ~p"/article_comments/#{article_comment}", article_comment: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Article comment"
    end
  end

  describe "delete article_comment" do
    setup [:create_article_comment]

    test "deletes chosen article_comment", %{conn: conn, article_comment: article_comment} do
      conn = delete(conn, ~p"/article_comments/#{article_comment}")
      assert redirected_to(conn) == ~p"/article_comments"

      assert_error_sent 404, fn ->
        get(conn, ~p"/article_comments/#{article_comment}")
      end
    end
  end

  defp create_article_comment(_) do
    article_comment = article_comment_fixture()
    %{article_comment: article_comment}
  end
end
