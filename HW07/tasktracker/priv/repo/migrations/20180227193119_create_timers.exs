defmodule Tasktracker.Repo.Migrations.CreateTimers do
  use Ecto.Migration

  def change do
    create table(:timers) do
      add :start_time, :naive_datetime
      add :end_time, :naive_datetime
      add :todo_id, references(:todos, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:timers, [:todo_id])
  end
end
