defmodule TaskTrackerSPAWeb.TaskView do
  use TaskTrackerSPAWeb, :view
  alias TaskTrackerSPAWeb.TaskView
  alias TaskTrackerSPAWeb.UserView

  def render("index.json", %{tasks: tasks}) do
    %{data: render_many(tasks, TaskView, "task.json")}
  end

  def render("show.json", %{task: task}) do
    %{data: render_one(task, TaskView, "task.json")}
  end

  def render("task.json", %{task: task}) do
    %{id: task.id,
      name: task.name,
      assigned_to: task.assigned_to,
      description: task.description,
      minutes_worked: task.minutes_worked,
      completed: task.completed,
      body: task.body,
      user: render_one(task.user, UserView, "user.json")}
  end
end
