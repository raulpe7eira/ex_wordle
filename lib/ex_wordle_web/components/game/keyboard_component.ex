defmodule ExWordleWeb.Game.KeyboardComponent do
  use Phoenix.Component

  def keyboard(assigns) do
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
