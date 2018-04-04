defmodule TaskTrackerSPA.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :name, :string, null: false
      add :assigned_to, :string, null: false
      add :description, :text
      add :minutes_worked, :integer, default: 0
      add :completed, :boolean, default: false, null: false
      add :body, :text, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:tasks, [:user_id])
  end
end
