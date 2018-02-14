defmodule MemoryWeb.GamesChannel do
  use MemoryWeb, :channel

  alias Memory.Game
  
  def join("games:" <> name, payload, socket) do
    if authorized?(payload) do
      game = Memory.GameBackup.load(name) || Game.new()
      socket = socket
      |> assign(:game, game)
      |> assign(:name, name)
      {:ok, %{"join" => name, "game" => Game.client_view(game)}, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def join("games:lobby", payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

    def join("games:" <> name, payload, socket) do
    if authorized?(payload) do
      {:ok, %{"join" => name}, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_in("double", payload, socket) do
    xx = String.to_integer(payload["xx"])
    resp = %{  "xx" => xx, "yy" => 2 * xx }
    {:reply, {:doubled, resp}, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (games:lobby).
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  def handle_in("reset",payload, socket) do
    game = Game.new()
    socket = socket
    |> assign(:game, game)
    #socket = assign(socket, :game, game)
    {:reply, {:ok, %{"game" => Game.client_view(game)}}, socket}
  end

  def handle_in("toggleDisplay", cardId, socket) do
    game = Game.toggleDisplay(socket.assigns[:game], cardId)
    Memory.GameBackup.save(socket.assigns[:name], game)
    socket = socket
    |> assign(:game, game)
    
    {:reply, {:ok, %{"game" => Game.client_view(game)}}, socket}
  end

  def handle_in("getGameState", payload, socket) do
    game = Game.getGameState(socket.assigns[:game])
    socket = socket
    |> assign(:game, game)
    {:reply, {:ok, %{"game" => Game.client_view(game)}}, socket}
  end

  def handle_in("goToSleep", payload,socket) do
    game = Game.goToSleep(socket.assigns[:game])
    socket = socket
    |> assign(:game, game)
    #socket = assign(socket, :game, game)
    {:reply, {:ok, %{"game" => Game.client_view(game)}}, socket}
  end

  def handle_in("wakeFromSleep", payload,socket) do
    game = Game.wakeFromSleep(socket.assigns[:game])
    socket = socket
    |> assign(:game, game)
    socket = assign(socket, :game, game)
    {:reply, {:ok, %{"game" => Game.client_view(game)}}, socket}
  end

  def handle_in("displayCard", %{"key"=> cardId}, socket) do
    game = Game.displayCard(socket.assigns[:game], cardId)
    socket = assign(socket, :game, game)
    {:reply, {:ok, %{"game" => Game.client_view(game)}}, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
