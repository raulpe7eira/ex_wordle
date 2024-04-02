defmodule ExWordle.Game do
  defstruct attempts: ["", "", "", "", "", ""],
            keys_attempted: "",
            keys_attempted_state: %{},
            state: :playing,
            row: 0,
            word: ""

  def new(word) do
    __struct__(word: word)
  end

  def update(game, updated_fields) do
    Map.merge(game, updated_fields)
  end
end
