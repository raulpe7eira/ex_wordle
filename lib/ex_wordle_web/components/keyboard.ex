defmodule ExWordleWeb.Keyboard do
  use Phoenix.Component

  alias ExWordle.Game

  @keyword_lines [
    ~w[Q W E R T Y U I O P],
    ~w[A S D F G H J K L],
    ~w[ENTER Z X C V B N M BACKSPACE]
  ]

  attr :game, Game, required: true

  def render(assigns) do
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

  defp keyboard_background(keys_attempted_state, key) do
    case Map.get(keys_attempted_state, key) do
      :found_in_position -> "bg-green-600"
      :found -> "bg-yellow-600"
      :not_found -> "bg-gray-800"
      nil -> "bg-gray-500"
    end
  end
end
