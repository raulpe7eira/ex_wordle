defmodule ExWordleWeb.WordleLive.Index do
  use ExWordleWeb, :live_view

  alias ExWordleWeb.Game.WordleComponent

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
