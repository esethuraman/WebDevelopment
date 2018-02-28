defmodule TasktrackerWeb.TodoController do
  use TasktrackerWeb, :controller

  alias Tasktracker.TrackerApp
  alias Tasktracker.TrackerApp.Todo
  alias Tasktracker.Accounts

  def index(conn, _params) do
    todos = TrackerApp.list_todos()
    render(conn, "index.html", todos: todos)
  end

  def new(conn, _params) do
    changeset = TrackerApp.change_todo(%Todo{})
    all_users = Accounts.list_users
    render(conn, "new.html", changeset: changeset, all_users: all_users)
  end

  def create(conn, %{"todo" => todo_params}) do
    all_users = Accounts.list_users
    case TrackerApp.create_todo(todo_params) do
      {:ok, todo} ->
        conn
        |> put_flash(:info, "Todo created successfully.")
        |> redirect(to: todo_path(conn, :show, todo))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, all_users: all_users)
    end
  end

  def show(conn, %{"id" => id}) do
    todo = TrackerApp.get_todo!(id)
    tmrs = Tasktracker.TaskTracker.list_timers()
    render(conn, "show.html", todo: todo, tmrs: tmrs)
  end

  def edit(conn, %{"id" => id}) do
    todo = TrackerApp.get_todo!(id)
    changeset = TrackerApp.change_todo(todo)
    all_users = Accounts.list_users()
    tmrs = Tasktracker.TaskTracker.list_timers()
    render(conn, "edit.html", todo: todo,tmrs: tmrs, changeset: changeset, all_users: all_users)
  end

  def update(conn, %{"id" => id, "todo" => todo_params}) do
    todo = TrackerApp.get_todo!(id)
    all_users = Accounts.list_users()
    tmrs = Tasktracker.TaskTracker.list_timers()
    case TrackerApp.update_todo(todo, todo_params) do

      {:ok, todo} ->
        conn
        |> put_flash(:info, "Todo updated successfully.")
        |> redirect(to: todo_path(conn, :show, todo))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", todo: todo,tmrs: tmrs, changeset: changeset, all_users: all_users)
    end
  end

  def delete(conn, %{"id" => id}) do
    todo = TrackerApp.get_todo!(id)
    {:ok, _todo} = TrackerApp.delete_todo(todo)

    conn
    |> put_flash(:info, "Task deleted successfully.")
    |> redirect(to: page_path(conn, :dashboard))
  end

end
