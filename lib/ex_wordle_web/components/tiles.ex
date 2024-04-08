defmodule ExWordleWeb.Tiles do
  use Phoenix.Component

  alias ExWordle.Game

  attr :game, Game, required: true

  def render(assigns) do
    ~H"""
    <div class="gap-3 grid grid-rows-6">
      <div
        :for={{attempt, row} <- Enum.with_index(@game.attempts)}
        id={tiles_row_id(row)}
        class="flex gap-3 justify-center"
      >
        <div :for={col <- 0..4} id={tile_id(row, col)} phx-hook="WordleEvents">
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

  def get_tile_id(game) do
    col = String.length(game.keys_attempted) - 1
    %{id: tile_id(game.row, col)}
  end

  def get_tiles_row_id(game) do
    %{id: tiles_row_id(game.row)}
  end

  defp tile_background(%{state: :playing, row: row}, row, _col, _key_attempted),
    do: "bg-transparent text-gray-900"

  defp tile_background(game, row, _col, _key_attempted) when row > game.row,
    do: "bg-transparent text-gray-900"

  defp tile_background(game, _row, col, key_attempted) do
    case Game.Engine.key_attempted_state(game, key_attempted, col) do
      :found_in_position -> "bg-green-600 text-gray-300"
      :found -> "bg-yellow-600 text-gray-300"
      :not_found -> "bg-gray-600 text-gray-300"
    end
  end

  defp tile_id(row, col), do: "tile-#{row}-#{col}"

  defp tiles_row_id(row), do: "tiles-row-#{row}"
end
