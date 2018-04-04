defmodule TaskTrackerSPA.App.Task do
  use Ecto.Schema
  import Ecto.Changeset


  schema "tasks" do
    field :assigned_to, :string
    field :body, :string
    field :completed, :boolean, default: false
    field :description, :string
    field :minutes_worked, :integer
    field :name, :string
    #field :assigned_by, :user_id

    belongs_to :user, TaskTrackerSPA.Users.User

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:name, :assigned_to, :description, :minutes_worked, :completed, :body, :user_id])
    |> validate_required([:name, :assigned_to, :description, :minutes_worked, :completed, :body, :user_id])
  end
end
