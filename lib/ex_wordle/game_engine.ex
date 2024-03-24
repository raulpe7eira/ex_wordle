defmodule ExWordle.GameEngine do
  defstruct attempts: ["", "", "", "", "", ""],
            keys_attempted: "",
            state: :playing,
            row_index: 0,
            correct_word: ""

  @valid_keys ~w[Q W E R T Y U I O P A S D F G H J K L Ç Z X C V B N M]

  def new do
    __struct__()
  end

  def add_key_attempted(game, key_attempted) do
    if row_is_not_completed?(game.keys_attempted) and valid_key?(key_attempted) do
      new_keys_attempted = game.keys_attempted <> key_attempted

      update_game(game, %{
        attempts: update_attempts(game, new_keys_attempted),
        keys_attempted: new_keys_attempted
      })
    else
      game
    end
  end

  defp row_is_not_completed?(keys_attempted) do
    String.length(keys_attempted) < 5
  end

  defp valid_key?(key_attempted) do
    key_attempted in @valid_keys
  end

  defp update_attempts(game, new_keys_attempted) do
    List.replace_at(game.attempts, game.row_index, new_keys_attempted)
  end

  defp update_game(game, updated_fields) do
    Map.merge(game, updated_fields)
  end
end
