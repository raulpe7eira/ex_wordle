defmodule ExWordleWeb.WordleLive.Index do
  use ExWordleWeb, :live_view

  import ExWordleWeb.Game.KeyboardComponent
  import ExWordleWeb.Game.TilesComponent

  @keyword_lines [
    ~w[Q W E R T Y U I O P],
    ~w[A S D F G H J K L],
    ~w[ENTER Z X C V B N M BACKSPACE]
  ]

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :keyword_lines, @keyword_lines)}
  end
end
