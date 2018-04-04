defmodule TaskTrackerSPAWeb.PageController do
  use TaskTrackerSPAWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
