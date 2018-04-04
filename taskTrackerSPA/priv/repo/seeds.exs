# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     TaskTrackerSPA.Repo.insert!(%TaskTrackerSPA.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.


defmodule Seeds do
  alias TaskTrackerSPA.Repo
  alias TaskTrackerSPA.Users.User
  alias TaskTrackerSPA.App.Task

  def run do
    p = Comeonin.Argon2.hashpwsalt("password1")

    Repo.delete_all(User)
    a = Repo.insert!(%User{ name: "alice", email: "alice@webdev.org", password_hash: p  })
    b = Repo.insert!(%User{ name: "bob", email: "bob@webdev.org", password_hash: p  })
    c = Repo.insert!(%User{ name: "carol", email: "carol@webdev.org", password_hash: p  })
    d = Repo.insert!(%User{ name: "dave", email: "dave@webdev.org", password_hash: p  })

    Repo.delete_all(Task)
    Repo.insert!(%Task{ user_id: a.id, name: "tasks_name", assigned_to: "random entity", minutes_worked: 0, completed: false, body: "body of the task", description: "description of the task"})
    Repo.insert!(%Task{ user_id: b.id, name: "tasks_name", assigned_to: "random entity", minutes_worked: 0, completed: false, body: "body of the task", description: "description of the task"})
    Repo.insert!(%Task{ user_id: b.id, name: "tasks_name", assigned_to: "random entity", minutes_worked: 0, completed: false, body: "body of the task", description: "description of the task"})
    Repo.insert!(%Task{ user_id: c.id, name: "tasks_name", assigned_to: "random entity", minutes_worked: 0, completed: false, body: "body of the task", description: "description of the task"})
    Repo.insert!(%Task{ user_id: d.id, name: "tasks_name", assigned_to: "random entity", minutes_worked: 0, completed: false, body: "body of the task", description: "description of the task"})
  end
end

Seeds.run
