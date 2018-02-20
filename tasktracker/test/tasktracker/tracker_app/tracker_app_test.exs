defmodule Tasktracker.TrackerAppTest do
  use Tasktracker.DataCase

  alias Tasktracker.TrackerApp

  describe "todos" do
    alias Tasktracker.TrackerApp.Todo

    @valid_attrs %{assigned_to: "some assigned_to", completed: true, description: "some description", hours: 42, name: "some name"}
    @update_attrs %{assigned_to: "some updated assigned_to", completed: false, description: "some updated description", hours: 43, name: "some updated name"}
    @invalid_attrs %{assigned_to: nil, completed: nil, description: nil, hours: nil, name: nil}

    def todo_fixture(attrs \\ %{}) do
      {:ok, todo} =
        attrs
        |> Enum.into(@valid_attrs)
        |> TrackerApp.create_todo()

      todo
    end

    test "list_todos/0 returns all todos" do
      todo = todo_fixture()
      assert TrackerApp.list_todos() == [todo]
    end

    test "get_todo!/1 returns the todo with given id" do
      todo = todo_fixture()
      assert TrackerApp.get_todo!(todo.id) == todo
    end

    test "create_todo/1 with valid data creates a todo" do
      assert {:ok, %Todo{} = todo} = TrackerApp.create_todo(@valid_attrs)
      assert todo.assigned_to == "some assigned_to"
      assert todo.completed == true
      assert todo.description == "some description"
      assert todo.hours == 42
      assert todo.name == "some name"
    end

    test "create_todo/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = TrackerApp.create_todo(@invalid_attrs)
    end

    test "update_todo/2 with valid data updates the todo" do
      todo = todo_fixture()
      assert {:ok, todo} = TrackerApp.update_todo(todo, @update_attrs)
      assert %Todo{} = todo
      assert todo.assigned_to == "some updated assigned_to"
      assert todo.completed == false
      assert todo.description == "some updated description"
      assert todo.hours == 43
      assert todo.name == "some updated name"
    end

    test "update_todo/2 with invalid data returns error changeset" do
      todo = todo_fixture()
      assert {:error, %Ecto.Changeset{}} = TrackerApp.update_todo(todo, @invalid_attrs)
      assert todo == TrackerApp.get_todo!(todo.id)
    end

    test "delete_todo/1 deletes the todo" do
      todo = todo_fixture()
      assert {:ok, %Todo{}} = TrackerApp.delete_todo(todo)
      assert_raise Ecto.NoResultsError, fn -> TrackerApp.get_todo!(todo.id) end
    end

    test "change_todo/1 returns a todo changeset" do
      todo = todo_fixture()
      assert %Ecto.Changeset{} = TrackerApp.change_todo(todo)
    end
  end
end
