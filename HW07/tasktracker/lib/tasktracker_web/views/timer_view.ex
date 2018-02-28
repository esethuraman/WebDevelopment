defmodule TasktrackerWeb.TimerView do
  use TasktrackerWeb, :view
  alias TasktrackerWeb.TimerView

  def render("index.json", %{timers: timers}) do
    %{data: render_many(timers, TimerView, "timer.json")}
  end

  def render("show.json", %{timer: timer}) do
    %{data: render_one(timer, TimerView, "timer.json")}
  end

  def render("timer.json", %{timer: timer}) do
    %{id: timer.id,
      start_time: timer.start_time,
      end_time: timer.end_time}
  end
end
