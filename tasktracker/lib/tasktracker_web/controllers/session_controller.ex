defmodule TasktrackerWeb.SessionController do
	use TasktrackerWeb, :controller 

	alias Tasktracker.Accounts
	alias Tasktracker.Accounts.User

	def create(conn, %{"email" => email}) do
		user = Accounts.get_user_by_email(email)
		if user do
			conn
			|> put_session(:user_id, user.id)
			|> put_flash(:info, "Welcome back #{user.name}")
			|> redirect(to: "/dashboard")
		else
			conn
			|> put_flash(:error, "Login Failed")
			|> redirect(to: page_path(conn, :index))
		end
	end

	def delete(conn, _params) do
		conn
		|> delete_session(:user_id)
		|> put_flash(:info, "Logged out")
		|> redirect(to: page_path(conn, :index))
	end

	def go_to_home(conn, _params) do
		conn
		|> delete_session(:user_id)
		|> redirect(to: page_path(conn, :index))
	end
end
