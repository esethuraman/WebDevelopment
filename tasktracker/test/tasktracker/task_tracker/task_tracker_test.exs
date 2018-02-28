defmodule Tasktracker.TaskTrackerTest do
  use Tasktracker.DataCase

  alias Tasktracker.TaskTracker

  describe "timers" do
    alias Tasktracker.TaskTracker.Timer

    @valid_attrs %{end_time: ~N[2010-04-17 14:00:00.000000], start_time: ~N[2010-04-17 14:00:00.000000]}
    @update_attrs %{end_time: ~N[2011-05-18 15:01:01.000000], start_time: ~N[2011-05-18 15:01:01.000000]}
    @invalid_attrs %{end_time: nil, start_time: nil}

    def timer_fixture(attrs \\ %{}) do
      {:ok, timer} =
        attrs
        |> Enum.into(@valid_attrs)
        |> TaskTracker.create_timer()

      timer
    end

    test "list_timers/0 returns all timers" do
      timer = timer_fixture()
      assert TaskTracker.list_timers() == [timer]
    end

    test "get_timer!/1 returns the timer with given id" do
      timer = timer_fixture()
      assert TaskTracker.get_timer!(timer.id) == timer
    end

    test "create_timer/1 with valid data creates a timer" do
      assert {:ok, %Timer{} = timer} = TaskTracker.create_timer(@valid_attrs)
      assert timer.end_time == ~N[2010-04-17 14:00:00.000000]
      assert timer.start_time == ~N[2010-04-17 14:00:00.000000]
    end

    test "create_timer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = TaskTracker.create_timer(@invalid_attrs)
    end

    test "update_timer/2 with valid data updates the timer" do
      timer = timer_fixture()
      assert {:ok, timer} = TaskTracker.update_timer(timer, @update_attrs)
      assert %Timer{} = timer
      assert timer.end_time == ~N[2011-05-18 15:01:01.000000]
      assert timer.start_time == ~N[2011-05-18 15:01:01.000000]
    end

    test "update_timer/2 with invalid data returns error changeset" do
      timer = timer_fixture()
      assert {:error, %Ecto.Changeset{}} = TaskTracker.update_timer(timer, @invalid_attrs)
      assert timer == TaskTracker.get_timer!(timer.id)
    end

    test "delete_timer/1 deletes the timer" do
      timer = timer_fixture()
      assert {:ok, %Timer{}} = TaskTracker.delete_timer(timer)
      assert_raise Ecto.NoResultsError, fn -> TaskTracker.get_timer!(timer.id) end
    end

    test "change_timer/1 returns a timer changeset" do
      timer = timer_fixture()
      assert %Ecto.Changeset{} = TaskTracker.change_timer(timer)
    end
  end
end
