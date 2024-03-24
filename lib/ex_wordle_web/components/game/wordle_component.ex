defmodule ExWordleWeb.Game.WordleComponent do
  use Phoenix.Component

  @keyword_lines [
    ~w[Q W E R T Y U I O P],
    ~w[A S D F G H J K L],
    ~w[ENTER Z X C V B N M BACKSPACE]
  ]

  def tiles(assigns) do
    ~H"""
    <div class="grid grid-rows-6 gap-1">
      <div
        :for={{_attempt, _row_index} <- Enum.with_index(["", "", "", "", "", ""])}
        class="pl-10 grid grid-cols-6 col-span-1 gap-x-0"
      >
        <div :for={_column_index <- 0..4} class="w-16 h-16">
          <button class="w-16 h-16 border border-gray-400">
            <span class="text-3xl subpixel-antialiased text-extrabold">A</span>
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
      <div class="flex flex-col items-center space-y-1">
        <div :for={key_line <- @keyword_lines} class="flex items-center space-x-1">
          <button
            :for={key <- key_line}
            class="p-4 rounded text-gray-200 text-md flex font-bold justify-center items-center uppercase focus:ring-2 bg-gray-500"
          >
            <%= key %>
          </button>
        </div>
      </div>
    </div>
    """
  end
end
