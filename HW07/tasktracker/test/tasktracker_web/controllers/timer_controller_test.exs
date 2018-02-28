defmodule TasktrackerWeb.TimerControllerTest do
  use TasktrackerWeb.ConnCase

  alias Tasktracker.TaskTracker
  alias Tasktracker.TaskTracker.Timer

  @create_attrs %{end_time: ~N[2010-04-17 14:00:00.000000], start_time: ~N[2010-04-17 14:00:00.000000]}
  @update_attrs %{end_time: ~N[2011-05-18 15:01:01.000000], start_time: ~N[2011-05-18 15:01:01.000000]}
  @invalid_attrs %{end_time: nil, start_time: nil}

  def fixture(:timer) do
    {:ok, timer} = TaskTracker.create_timer(@create_attrs)
    timer
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all timers", %{conn: conn} do
      conn = get conn, timer_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create timer" do
    test "renders timer when data is valid", %{conn: conn} do
      conn = post conn, timer_path(conn, :create), timer: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, timer_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "end_time" => ~N[2010-04-17 14:00:00.000000],
        "start_time" => ~N[2010-04-17 14:00:00.000000]}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, timer_path(conn, :create), timer: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update timer" do
    setup [:create_timer]

    test "renders timer when data is valid", %{conn: conn, timer: %Timer{id: id} = timer} do
      conn = put conn, timer_path(conn, :update, timer), timer: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, timer_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "end_time" => ~N[2011-05-18 15:01:01.000000],
        "start_time" => ~N[2011-05-18 15:01:01.000000]}
    end

    test "renders errors when data is invalid", %{conn: conn, timer: timer} do
      conn = put conn, timer_path(conn, :update, timer), timer: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete timer" do
    setup [:create_timer]

    test "deletes chosen timer", %{conn: conn, timer: timer} do
      conn = delete conn, timer_path(conn, :delete, timer)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, timer_path(conn, :show, timer)
      end
    end
  end

  defp create_timer(_) do
    timer = fixture(:timer)
    {:ok, timer: timer}
  end
end
