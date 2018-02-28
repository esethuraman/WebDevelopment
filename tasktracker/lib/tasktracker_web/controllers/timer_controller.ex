defmodule TasktrackerWeb.TimerController do
  use TasktrackerWeb, :controller

  alias Tasktracker.TaskTracker
  alias Tasktracker.TaskTracker.Timer

  action_fallback TasktrackerWeb.FallbackController

  def index(conn, _params) do
    timers = TaskTracker.list_timers()
    render(conn, "index.json", timers: timers)
  end

  def create(conn, %{"timer" => timer_params}) do
    with {:ok, %Timer{} = timer} <- TaskTracker.create_timer(timer_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", timer_path(conn, :show, timer))
      |> render("show.json", timer: timer)
    end
  end

  def show(conn, %{"id" => id}) do
    timer = TaskTracker.get_timer!(id)
    render(conn, "show.json", timer: timer)
  end

  def update(conn, %{"id" => id, "timer" => timer_params}) do
    timer = TaskTracker.get_timer!(id)

    with {:ok, %Timer{} = timer} <- TaskTracker.update_timer(timer, timer_params) do
      render(conn, "show.json", timer: timer)
    end
  end

  def delete(conn, %{"id" => id}) do
    timer = TaskTracker.get_timer!(id)
    with {:ok, %Timer{}} <- TaskTracker.delete_timer(timer) do
      send_resp(conn, :no_content, "")
    end
  end
end
