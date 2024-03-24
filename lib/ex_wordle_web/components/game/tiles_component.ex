defmodule ExWordleWeb.Game.TilesComponent do
  use Phoenix.Component

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
end
