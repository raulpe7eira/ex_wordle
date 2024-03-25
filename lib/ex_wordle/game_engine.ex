defmodule ExWordle.GameEngine do
  defstruct attempts: ["", "", "", "", "", ""],
            keys_attempted: "",
            state: :playing,
            row: 0,
            word: ""

  @valid_keys ~w[Q W E R T Y U I O P A S D F G H J K L Ç Z X C V B N M]

  def new(word) do
    __struct__(word: word)
  end

  def add_key_attempted(%{state: state} = game, _key_attempted) when state != :playing, do: game

  def add_key_attempted(game, key_attempted) do
    if row_is_completed?(game.keys_attempted) or invalid_key?(key_attempted) do
      game
    else
      new_keys_attempted = add_last_key(game, key_attempted)

      update_game(game, %{
        attempts: update_attempts(game, new_keys_attempted),
        keys_attempted: new_keys_attempted
      })
    end
  end

  def remove_key_attempted(%{state: state} = game) when state != :playing, do: game

  def remove_key_attempted(game) do
    if row_is_empty?(game.keys_attempted) do
      game
    else
      new_keys_attempted = remove_last_key(game)

      update_game(game, %{
        attempts: update_attempts(game, new_keys_attempted),
        keys_attempted: new_keys_attempted
      })
    end
  end

  def confirm_attempts(%{state: state} = game) when state != :playing, do: game

  def confirm_attempts(game) do
    if row_is_completed?(game.keys_attempted) do
      new_state = update_state(game)

      update_game(game, %{
        keys_attempted: "",
        state: new_state,
        row: update_row(game, new_state)
      })
    else
      game
    end
  end

  def found_key_attempted_in_position?(game, key_attempted, position) do
    key_attempted == String.at(game.word, position)
  end

  def found_key_attempted?(game, key_attempted) do
    key_attempted in String.graphemes(game.word)
  end

  defp add_last_key(game, key_attempted) do
    game.keys_attempted <> key_attempted
  end

  defp has_win_attempt?(attempts, word) do
    Enum.any?(attempts, &(&1 == word))
  end

  defp has_no_other_attempt?(attempts) do
    Enum.count(attempts, &(&1 != "")) == 6
  end

  defp invalid_key?(key_attempted) do
    key_attempted not in @valid_keys
  end

  defp row_is_completed?(keys_attempted) do
    String.length(keys_attempted) >= 5
  end

  defp row_is_empty?(keys_attempted) do
    String.length(keys_attempted) <= 0
  end

  defp remove_last_key(game) do
    game.keys_attempted
    |> String.graphemes()
    |> Enum.reverse()
    |> tl()
    |> Enum.reverse()
    |> Enum.join()
  end

  defp update_attempts(game, new_keys_attempted) do
    List.replace_at(game.attempts, game.row, new_keys_attempted)
  end

  defp update_row(game, :playing), do: game.row + 1
  defp update_row(game, _), do: game.row

  defp update_state(game) do
    cond do
      has_win_attempt?(game.attempts, game.word) -> :win
      has_no_other_attempt?(game.attempts) -> :lose
      true -> :playing
    end
  end

  defp update_game(game, updated_fields) do
    Map.merge(game, updated_fields)
  end
end
