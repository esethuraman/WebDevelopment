defmodule TasktrackerWeb.TodoControllerTest do
  use TasktrackerWeb.ConnCase

  alias Tasktracker.TrackerApp

  @create_attrs %{assigned_to: "some assigned_to", completed: true, description: "some description", hours: 42, name: "some name"}
  @update_attrs %{assigned_to: "some updated assigned_to", completed: false, description: "some updated description", hours: 43, name: "some updated name"}
  @invalid_attrs %{assigned_to: nil, completed: nil, description: nil, hours: nil, name: nil}

  def fixture(:todo) do
    {:ok, todo} = TrackerApp.create_todo(@create_attrs)
    todo
  end

  describe "index" do
    test "lists all todos", %{conn: conn} do
      conn = get conn, todo_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Todos"
    end
  end

  describe "new todo" do
    test "renders form", %{conn: conn} do
      conn = get conn, todo_path(conn, :new)
      assert html_response(conn, 200) =~ "New Todo"
    end
  end

  describe "create todo" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, todo_path(conn, :create), todo: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == todo_path(conn, :show, id)

      conn = get conn, todo_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Todo"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, todo_path(conn, :create), todo: @invalid_attrs
      assert html_response(conn, 200) =~ "New Todo"
    end
  end

  describe "edit todo" do
    setup [:create_todo]

    test "renders form for editing chosen todo", %{conn: conn, todo: todo} do
      conn = get conn, todo_path(conn, :edit, todo)
      assert html_response(conn, 200) =~ "Edit Todo"
    end
  end

  describe "update todo" do
    setup [:create_todo]

    test "redirects when data is valid", %{conn: conn, todo: todo} do
      conn = put conn, todo_path(conn, :update, todo), todo: @update_attrs
      assert redirected_to(conn) == todo_path(conn, :show, todo)

      conn = get conn, todo_path(conn, :show, todo)
      assert html_response(conn, 200) =~ "some updated assigned_to"
    end

    test "renders errors when data is invalid", %{conn: conn, todo: todo} do
      conn = put conn, todo_path(conn, :update, todo), todo: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Todo"
    end
  end

  describe "delete todo" do
    setup [:create_todo]

    test "deletes chosen todo", %{conn: conn, todo: todo} do
      conn = delete conn, todo_path(conn, :delete, todo)
      assert redirected_to(conn) == todo_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, todo_path(conn, :show, todo)
      end
    end
  end

  defp create_todo(_) do
    todo = fixture(:todo)
    {:ok, todo: todo}
  end
end
