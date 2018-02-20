defmodule Tasktracker.Repo.Migrations.CreateTodos do
  use Ecto.Migration

  def change do
    create table(:todos) do
      add :name, :string, null: false
      add :assigned_to, :string, null: false
      add :description, :text, null: false
      add :hours, :integer, null: false
      add :completed, :boolean, default: false, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:todos, [:user_id])
  end
end
