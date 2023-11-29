defmodule RealworldPhoenixWeb.ProfileFollowersControllerTest do
  use RealworldPhoenixWeb.ConnCase

  import RealworldPhoenix.AppFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  describe "index" do
    test "lists all profile_followers", %{conn: conn} do
      conn = get(conn, ~p"/profile_followers")
      assert html_response(conn, 200) =~ "Listing Profile followers"
    end
  end

  describe "new profile_followers" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/profile_followers/new")
      assert html_response(conn, 200) =~ "New Profile followers"
    end
  end

  describe "create profile_followers" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/profile_followers", profile_followers: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/profile_followers/#{id}"

      conn = get(conn, ~p"/profile_followers/#{id}")
      assert html_response(conn, 200) =~ "Profile followers #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/profile_followers", profile_followers: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Profile followers"
    end
  end

  describe "edit profile_followers" do
    setup [:create_profile_followers]

    test "renders form for editing chosen profile_followers", %{conn: conn, profile_followers: profile_followers} do
      conn = get(conn, ~p"/profile_followers/#{profile_followers}/edit")
      assert html_response(conn, 200) =~ "Edit Profile followers"
    end
  end

  describe "update profile_followers" do
    setup [:create_profile_followers]

    test "redirects when data is valid", %{conn: conn, profile_followers: profile_followers} do
      conn = put(conn, ~p"/profile_followers/#{profile_followers}", profile_followers: @update_attrs)
      assert redirected_to(conn) == ~p"/profile_followers/#{profile_followers}"

      conn = get(conn, ~p"/profile_followers/#{profile_followers}")
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, profile_followers: profile_followers} do
      conn = put(conn, ~p"/profile_followers/#{profile_followers}", profile_followers: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Profile followers"
    end
  end

  describe "delete profile_followers" do
    setup [:create_profile_followers]

    test "deletes chosen profile_followers", %{conn: conn, profile_followers: profile_followers} do
      conn = delete(conn, ~p"/profile_followers/#{profile_followers}")
      assert redirected_to(conn) == ~p"/profile_followers"

      assert_error_sent 404, fn ->
        get(conn, ~p"/profile_followers/#{profile_followers}")
      end
    end
  end

  defp create_profile_followers(_) do
    profile_followers = profile_followers_fixture()
    %{profile_followers: profile_followers}
  end
end
