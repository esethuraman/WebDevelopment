defmodule TaskTrackerSPAWeb.UserController do
  use TaskTrackerSPAWeb, :controller

  alias TaskTrackerSPA.Users
  alias TaskTrackerSPA.Users.User
  alias TaskTrackerSPA.Repo

  action_fallback TaskTrackerSPAWeb.FallbackController

  def index(conn, _params) do
    users = Users.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    IO.inspect("LJSFDKJDLFJDSLFJDSLFKJDLFJSLD");
    IO.inspect(user_params)
    p = Comeonin.Argon2.hashpwsalt(user_params["pass"])
    with {:ok, %User{} = user} <- Repo.insert!(%User{ name: user_params["name"], 
    email: user_params["email"], password_hash: p  }) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
    #with {:ok, %User{} = user} <- Users.create_user(user_params) do
    #  conn
    #  |> put_status(:created)
    #  |> put_resp_header("location", user_path(conn, :show, user))
    #  |> render("show.json", user: user)
    #end
  end

  def show(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Users.get_user!(id)

    with {:ok, %User{} = user} <- Users.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    with {:ok, %User{}} <- Users.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
