defmodule Tasktracker.TrackerApp do
  @moduledoc """
  The TrackerApp context.
  """

  import Ecto.Query, warn: false
  alias Tasktracker.Repo

  alias Tasktracker.TrackerApp.Todo

  @doc """
  Returns the list of todos.

  ## Examples

      iex> list_todos()
      [%Todo{}, ...]

  """
  def list_todos do
  # |> Enum.filter((fn(x) -> (@current_user.name == "raghu") end))
    Repo.all(Todo)
    |> Repo.preload(:user)
  end


  def get_todo_by_managerId(managerId) do
    # todo.user.manager == managerId
    Repo.all(Todo)
    |> Repo.preload(:user)
    |> Enum.filter(fn(todo) -> (todo.user.manager == managerId) end)

  end


  @doc """
  Gets a single todo.

  Raises `Ecto.NoResultsError` if the Todo does not exist

  ## Examples

      iex> get_todo!(123)
      %Todo{}

      iex> get_todo!(456)
      ** (Ecto.NoResultsError)

  """
  def get_todo!(id) do
    Repo.get!(Todo, id)
    |> Repo.preload(:user)
  end

  @doc """
  Creates a todo.

  ## Examples

      iex> create_todo(%{field: value})
      {:ok, %Todo{}}

      iex> create_todo(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_todo(attrs \\ %{}) do
    %Todo{}
    |> Todo.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a todo.

  ## Examples

      iex> update_todo(todo, %{field: new_value})
      {:ok, %Todo{}}

      iex> update_todo(todo, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_todo(%Todo{} = todo, attrs) do
    todo
    |> Todo.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Todo.

  ## Examples

      iex> delete_todo(todo)
      {:ok, %Todo{}}

      iex> delete_todo(todo)
      {:error, %Ecto.Changeset{}}

  """
  def delete_todo(%Todo{} = todo) do
    Repo.delete(todo)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking todo changes.

  ## Examples

      iex> change_todo(todo)
      %Ecto.Changeset{source: %Todo{}}

  """
  def change_todo(%Todo{} = todo) do
    Todo.changeset(todo, %{})
  end
end
