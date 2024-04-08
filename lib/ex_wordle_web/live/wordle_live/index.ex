defmodule ExWordleWeb.WordleLive.Index do
  use ExWordleWeb, :live_view

  alias ExWordle.Game
  alias ExWordleWeb.ModalGameOver
  alias ExWordleWeb.WordleComponents

  @words ~w[PLACE WINNE GREAT]

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :game, request_game())}
  end

  @impl Phoenix.LiveView
  def handle_event("handle-key-click", %{"key" => "BACKSPACE"}, socket) do
    {:noreply, remove_key_attempted(socket)}
  end

  @impl Phoenix.LiveView
  def handle_event("handle-key-click", %{"key" => "ENTER"}, socket) do
    {:noreply, confirm_attempts(socket)}
  end

  @impl Phoenix.LiveView
  def handle_event("handle-key-click", %{"key" => key_attempted}, socket) do
    {:noreply, add_key_attempted(socket, key_attempted)}
  end

  @impl Phoenix.LiveView
  def handle_event("handle-key-keydown", %{"key" => "Backspace"}, socket) do
    {:noreply, remove_key_attempted(socket)}
  end

  @impl Phoenix.LiveView
  def handle_event("handle-key-keydown", %{"key" => "Enter"}, socket) do
    {:noreply, confirm_attempts(socket)}
  end

  @impl Phoenix.LiveView
  def handle_event("handle-key-keydown", %{"key" => key_attempted}, socket) do
    {:noreply, add_key_attempted(socket, key_attempted)}
  end

  defp add_key_attempted(socket, key_attempted) do
    case Game.Engine.add_key_attempted(socket.assigns.game, key_attempted) do
      {:ok, game} ->
        socket
        |> assign(:game, game)
        |> push_event("pop", WordleComponents.get_tile_id(game))

      {:error, _} ->
        socket
    end
  end

  defp confirm_attempts(socket) do
    case Game.Engine.confirm_attempts(socket.assigns.game) do
      {:ok, game} ->
        socket
        |> assign(:game, game)
        |> push_event("rotate", WordleComponents.get_tile_row_id(socket.assigns.game))

      {:error, _} ->
        push_event(socket, "wiggle", WordleComponents.get_tile_row_id(socket.assigns.game))
    end
  end

  defp remove_key_attempted(socket) do
    case Game.Engine.remove_key_attempted(socket.assigns.game) do
      {:ok, game} ->
        socket
        |> assign(:game, game)
        |> push_event("unpop", WordleComponents.get_tile_id(socket.assigns.game))

      {:error, _} ->
        socket
    end
  end

  defp request_game() do
    @words
    |> Enum.random()
    |> Game.Engine.new()
  end
end
