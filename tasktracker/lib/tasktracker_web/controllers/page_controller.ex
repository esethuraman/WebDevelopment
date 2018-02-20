defmodule TasktrackerWeb.PageController do
  use TasktrackerWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def dashboard(conn, _params) do
  	todos = Tasktracker.TrackerApp.list_todos()
  	new_todo = %Tasktracker.TrackerApp.Todo{user_id: conn.assigns[:current_user].id}
  	changeset = Tasktracker.TrackerApp.change_todo(new_todo)
  	all_users = Tasktracker.Accounts.list_users
  	render conn, "dashboard.html", todos: todos, changeset: changeset, all_users: all_users
  end

end
