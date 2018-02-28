defmodule Tasktracker.App.Task do
  use Ecto.Schema
  import Ecto.Changeset
  alias Tasktracker.App.Task


  schema "tasks" do
    field :assigned_to, :string
    field :body, :string
    field :completed, :boolean, default: false
    field :description, :string
    field :hours_worked, :integer, default: 0
    field :name, :string
    field :assigned_by, :string


    timestamps()
  end

  @doc false
  def changeset(%Task{} = task, attrs) do
    task
    |> cast(attrs, [:name, :assigned_to, :description, :hours_worked, :completed, :body])
    |> validate_required([:name, :assigned_to, :description, :hours_worked, :completed, :body])
  end
end
