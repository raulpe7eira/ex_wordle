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
      <div :for={{attempt, row} <- Enum.with_index(@game.attempts)} class="flex gap-3 justify-center">
        <div :for={col <- 0..4}>
          <% key_attempted = String.at(attempt, col) %>
          <button class={[
            "border border-gray-400 h-16 rounded-md w-16",
            tile_background(@game, row, col, key_attempted)
          ]}>
            <span class="subpixel-antialiased text-3xl text-extrabold">
              <%= key_attempted %>
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
            class={[
              "flex focus:ring-2 font-bold items-center justify-center p-3 rounded text-gray-200 text-md uppercase",
              keyboard_background(@game.keys_attempted_state, key)
            ]}
            phx-click="handle-key-click"
            phx-value-key={key}
          >
            <%= key %>
          </button>
        </div>
      </div>
    </div>
    """
  end

  defp tile_background(%{state: :playing, row: row}, row, _col, _key_attempted),
    do: "bg-transparent text-gray-900"

  defp tile_background(game, row, _col, _key_attempted) when row > game.row,
    do: "bg-transparent text-gray-900"

  defp tile_background(game, _row, col, key_attempted) do
    case GameEngine.key_attempted_state(game, key_attempted, col) do
      :found_in_position -> "bg-green-600 text-gray-300"
      :found -> "bg-yellow-600 text-gray-300"
      :not_found -> "bg-gray-600 text-gray-300"
    end
  end

  defp keyboard_background(keys_attempted_state, key) do
    case Map.get(keys_attempted_state, key) do
      :found_in_position -> "bg-green-600"
      :found -> "bg-yellow-600"
      :not_found -> "bg-gray-800"
      nil -> "bg-gray-500"
    end
  end
end
