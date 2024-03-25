defmodule ExWordleWeb.Game.WordleComponent do
  use Phoenix.Component

  alias ExWordle.GameEngine

  @keyword_lines [
    ~w[Q W E R T Y U I O P],
    ~w[A S D F G H J K L],
    ~w[ENTER Z X C V B N M BACKSPACE]
  ]

  attr :game, GameEngine

  def tiles(assigns) do
    ~H"""
    <div class="gap-3 grid grid-rows-6">
      <div
        :for={{attempt, _row_index} <- Enum.with_index(@game.attempts)}
        class="flex gap-3 justify-center"
      >
        <div :for={key_attempted_index <- 0..4}>
          <button class="border border-gray-400 h-16 rounded-md w-16">
            <span class="subpixel-antialiased text-3xl text-extrabold">
              <%= key_attempted_value(attempt, key_attempted_index) %>
            </span>
          </button>
        </div>
      </div>
    </div>
    """
  end

  def keyboard(assigns) do
    assigns = assign(assigns, :keyword_lines, @keyword_lines)

    ~H"""
    <div>
      <div class="flex flex-col items-center md:space-y-2 space-y-1">
        <div :for={keyboard_line <- @keyword_lines} class="flex items-center md:space-x-2 space-x-1">
          <button
            :for={key <- keyboard_line}
            class="bg-gray-500 flex focus:ring-2 font-bold items-center justify-center p-3 rounded text-gray-200 text-md uppercase"
            phx-click="handle-key-clicked"
            phx-value-key={key}
          >
            <%= key %>
          </button>
        </div>
      </div>
    </div>
    """
  end

  defp key_attempted_value(attempt, key_attempted_index) do
    attempt
    |> String.graphemes()
    |> Enum.at(key_attempted_index)
  end
end
