defmodule Tasktracker.AppTest do
  use Tasktracker.DataCase

  alias Tasktracker.App

  describe "tasks" do
    alias Tasktracker.App.Task

    @valid_attrs %{assigned_to: "some assigned_to", body: "some body", completed: true, description: "some description", hours_worked: 42, name: "some name"}
    @update_attrs %{assigned_to: "some updated assigned_to", body: "some updated body", completed: false, description: "some updated description", hours_worked: 43, name: "some updated name"}
    @invalid_attrs %{assigned_to: nil, body: nil, completed: nil, description: nil, hours_worked: nil, name: nil}

    def task_fixture(attrs \\ %{}) do
      {:ok, task} =
        attrs
        |> Enum.into(@valid_attrs)
        |> App.create_task()

      task
    end

    test "list_tasks/0 returns all tasks" do
      task = task_fixture()
      assert App.list_tasks() == [task]
    end

    test "get_task!/1 returns the task with given id" do
      task = task_fixture()
      assert App.get_task!(task.id) == task
    end

    test "create_task/1 with valid data creates a task" do
      assert {:ok, %Task{} = task} = App.create_task(@valid_attrs)
      assert task.assigned_to == "some assigned_to"
      assert task.body == "some body"
      assert task.completed == true
      assert task.description == "some description"
      assert task.hours_worked == 42
      assert task.name == "some name"
    end

    test "create_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = App.create_task(@invalid_attrs)
    end

    test "update_task/2 with valid data updates the task" do
      task = task_fixture()
      assert {:ok, task} = App.update_task(task, @update_attrs)
      assert %Task{} = task
      assert task.assigned_to == "some updated assigned_to"
      assert task.body == "some updated body"
      assert task.completed == false
      assert task.description == "some updated description"
      assert task.hours_worked == 43
      assert task.name == "some updated name"
    end

    test "update_task/2 with invalid data returns error changeset" do
      task = task_fixture()
      assert {:error, %Ecto.Changeset{}} = App.update_task(task, @invalid_attrs)
      assert task == App.get_task!(task.id)
    end

    test "delete_task/1 deletes the task" do
      task = task_fixture()
      assert {:ok, %Task{}} = App.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> App.get_task!(task.id) end
    end

    test "change_task/1 returns a task changeset" do
      task = task_fixture()
      assert %Ecto.Changeset{} = App.change_task(task)
    end
  end
end
