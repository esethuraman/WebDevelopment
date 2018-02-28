defmodule Tasktracker.Repo.Migrations.AddFieldsToUsers do
  use Ecto.Migration

  def change do
    alter table(:todos) do
	     add :assigned_by, :string
    end
  end
end
