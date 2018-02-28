defmodule Tasktracker.TaskTracker.Timer do
  use Ecto.Schema
  import Ecto.Changeset
  alias Tasktracker.TaskTracker.Timer


  schema "timers" do
    field :end_time, :naive_datetime
    field :start_time, :naive_datetime
    #field :todo_id, :id
    belongs_to :todo, Tasktracker.TrackerApp.Todo

    timestamps()
  end

  @doc false
  def changeset(%Timer{} = timer, attrs) do
    timer
    |> cast(attrs, [:start_time, :end_time, :todo_id])
    |> validate_required([:start_time, :todo_id])
  end
end
