defmodule Tasktracker.Repo.Migrations.AddFieldsToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :manager, :integer
    end
  end
end
