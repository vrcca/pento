defmodule PentoWeb.UserRegistrationControllerTest do
  use PentoWeb.ConnCase

  import Pento.AccountsFixtures

  describe "GET /users/register" do
    test "renders registration page", %{conn: conn} do
      conn = get(conn, Routes.user_registration_path(conn, :new))
      response = html_response(conn, 200)
      assert response =~ "<h1>Register</h1>"
      assert response =~ "Log in</a>"
      assert response =~ "Register</a>"
    end

    test "redirects if already logged in", %{conn: conn} do
      conn = conn |> log_in_user(user_fixture()) |> get(Routes.user_registration_path(conn, :new))
      assert redirected_to(conn) == "/"
    end
  end

  describe "POST /users/register" do
    @tag :capture_log
    test "creates account and logs the user in", %{conn: conn} do
      email = unique_user_email()
      username = unique_user_username()

      conn =
        post(conn, Routes.user_registration_path(conn, :create), %{
          "user" => valid_user_attributes(username: username, email: email)
        })

      assert get_session(conn, :user_token)
      assert "/" = redir_path = redirected_to(conn, 302)
      conn = get(recycle(conn), redir_path)
      assert "/guess" = redir_path = redirected_to(conn, 302)

      # Now do a logged in request and assert on the menu
      conn = get(recycle(conn), redir_path)
      response = html_response(conn, 200)
      assert response =~ username
      assert response =~ "Settings</a>"
      assert response =~ "Log out</a>"
    end

    test "render errors for invalid data", %{conn: conn} do
      conn =
        post(conn, Routes.user_registration_path(conn, :create), %{
          "user" => %{
            "email" => "with spaces",
            "password" => "too short",
            "username" => "with spaces too"
          }
        })

      response = html_response(conn, 200)
      assert response =~ "<h1>Register</h1>"
      assert response =~ "accepts letters and numbers only"
      assert response =~ "must have the @ sign and no spaces"
      assert response =~ "should be at least 12 character"
    end
  end
end
