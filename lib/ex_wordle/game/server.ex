defmodule ExWordle.Game.Server do
  use GenServer

  @words ~w[PLACE WINNE GREAT]

  def start_link(initial_state) do
    GenServer.start_link(__MODULE__, initial_state, name: __MODULE__)
  end

  def get_daily_word do
    GenServer.call(__MODULE__, :get_word)
  end

  @impl true
  def init(initial_state) do
    schedule_work()

    {:ok, initial_state, {:continue, :set_word}}
  end

  @impl true
  def handle_call(:get_word, _from, %{word: word} = state) do
    {:reply, word, state}
  end

  @impl true
  def handle_continue(:set_word, _state) do
    {:noreply, %{date: Date.utc_today(), word: Enum.random(@words)}}
  end

  @impl true
  def handle_info(:check_time, state) do
    schedule_work()

    if state.date != Date.utc_today() do
      {:noreply, %{date: Date.utc_today(), word: Enum.random(@words)}}
    else
      {:noreply, state}
    end
  end

  defp schedule_work() do
    Process.send_after(self(), :check_time, :timer.seconds(60))
  end
end
