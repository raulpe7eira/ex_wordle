defmodule ExWordleWeb.ModalGameOver do
  use Phoenix.Component
  import ExWordleWeb.CoreComponents

  alias ExWordle.Game

  attr :id, :string, required: true
  attr :game, Game, required: true

  def show(assigns) do
    ~H"""
    <div
      id={@id}
      phx-mounted={show_modal(@id)}
      class="hidden relative z-10"
      aria-labelledby="modal-title"
      role="dialog"
      aria-modal="true"
    >
      <div
        id={"#{@id}-bg"}
        class="bg-gray-500 bg-opacity-75 fixed inset-0 transition-opacity"
        aria-hidden="true"
      >
      </div>

      <div class="fixed inset-0 overflow-y-auto z-10">
        <div class="flex items-end justify-center min-h-full p-4 sm:items-center sm:p-0 text-center">
          <.result state={@game.state} />
        </div>
      </div>
    </div>
    """
  end

  defp result(%{state: :lose} = assigns) do
    ~H"""
    <div class="bg-white overflow-hidden pb-4 pt-5 px-4 relative rounded-lg shadow-xl sm:max-w-sm sm:my-8 sm:p-6 sm:w-full text-left transform">
      <div class="bg-red-100 flex h-12 items-center justify-center mx-auto rounded-full w-12">
        <.icon name="hero-x-mark" class="h-6 text-red-600 w-6" />
      </div>
      <div class="mt-3 sm:mt-5 text-center">
        <h3 class="font-semibold leading-6 text-base text-gray-900" id="modal-title">
          I am so sorry! Nevermind, tomorrow you can try again!
        </h3>
        <div class="mt-2">
          <p class="text-gray-500 text-sm">
            Tomorrow is a new day and a new challenge is waiting for you!
          </p>
        </div>
      </div>
    </div>
    """
  end

  defp result(%{state: :win} = assigns) do
    ~H"""
    <div class="bg-white overflow-hidden pb-4 pt-5 px-4 relative rounded-lg shadow-xl sm:max-w-sm sm:my-8 sm:p-6 sm:w-full text-left transform">
      <div class="bg-green-100 flex h-12 items-center justify-center mx-auto rounded-full w-12">
        <.icon name="hero-check" class="h-6 text-green-600 w-6" />
      </div>
      <div class="mt-3 sm:mt-5 text-center">
        <h3 class="font-semibold leading-6 text-base text-gray-900" id="modal-title">
          Congratulations! You won today!
        </h3>
        <div class="mt-2">
          <p class="text-gray-500 text-sm">
            Come back tomorrow for a new adventure!
          </p>
        </div>
      </div>
    </div>
    """
  end
end
