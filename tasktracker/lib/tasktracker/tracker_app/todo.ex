defmodule Tasktracker.TrackerApp.Todo do
  use Ecto.Schema
  import Ecto.Changeset
  alias Tasktracker.TrackerApp.Todo


  schema "todos" do
    field :assigned_to, :string
    field :completed, :boolean, default: false
    field :description, :string
    field :hours, :integer
    field :name, :string
    #field :user_id, :id
    field :assigned_by, :string

    belongs_to :user, Tasktracker.Accounts.User
    has_many :timers, Tasktracker.TaskTracker.Timer

    timestamps()
  end

  @doc false
  def changeset(%Todo{} = todo, attrs) do
    todo
    |> cast(attrs, [:name, :assigned_to, :description, :completed, :user_id, :hours])
    |> validate_required([:name, :assigned_to, :description, :completed, :user_id])
  end
end
