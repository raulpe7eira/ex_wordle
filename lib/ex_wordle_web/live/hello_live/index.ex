defmodule ExWordleWeb.HelloLive.Index do
  use ExWordleWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:form, %{"input" => ""})
     |> assign(:output, "")}
  end

  def handle_event("change-input", %{"input" => ""}, socket) do
    {:noreply, assign(socket, :output, "")}
  end

  def handle_event("change-input", %{"input" => value}, socket) do
    {:noreply, assign(socket, :output, "Hello #{value}")}
  end
end
