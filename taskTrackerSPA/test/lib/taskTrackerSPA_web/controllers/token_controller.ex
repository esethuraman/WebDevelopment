defmodule TaskTrackerSPAWeb.TokenController do
  use TaskTrackerSPAWeb, :controller
  alias TaskTrackerSPA.Users.User

  action_fallback TaskTrackerSPAWeb.FallbackController

  def create(conn, %{"email" => email, "pass" => pass}) do
    with {:ok, %User{} = user} <- TaskTrackerSPA.Users.get_and_auth_user(email, pass) do
      token = Phoenix.Token.sign(conn, "auth token", user.id)
      conn
      |> put_status(:created)
      |> render("token.json", user: user, token: token)
    end
  end
end
