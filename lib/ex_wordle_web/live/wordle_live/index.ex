defmodule ExWordleWeb.WordleLive.Index do
  use ExWordleWeb, :live_view

  alias ExWordle.GameEngine
  alias ExWordleWeb.Game.WordleComponent

  @words ~w[PLACE WINNE GREAT]

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :game, request_game())}
  end

  @impl Phoenix.LiveView
  def handle_event("handle-key-clicked", %{"key" => "BACKSPACE"}, socket) do
    game = remove_key_attempted(socket.assigns.game)
    {:noreply, assign(socket, :game, game)}
  end

  @impl Phoenix.LiveView
  def handle_event("handle-key-clicked", %{"key" => "ENTER"}, socket) do
    game = confirm_attempts(socket.assigns.game)
    {:noreply, assign(socket, :game, game)}
  end

  @impl Phoenix.LiveView
  def handle_event("handle-key-clicked", %{"key" => key_attempted}, socket) do
    game = add_key_attempted(socket.assigns.game, key_attempted)
    {:noreply, assign(socket, :game, game)}
  end

  defp add_key_attempted(game, key_attempted) do
    GameEngine.add_key_attempted(game, key_attempted)
  end

  defp confirm_attempts(game) do
    GameEngine.confirm_attempts(game)
  end

  defp remove_key_attempted(game) do
    GameEngine.remove_key_attempted(game)
  end

  defp request_game() do
    @words
    |> Enum.random()
    |> GameEngine.new()
  end
end
