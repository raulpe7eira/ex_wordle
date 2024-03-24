defmodule ExWordle.GameEngine do
  defstruct attempts: ["", "", "", "", "", ""],
            keys_attempted: "",
            state: :playing,
            row_index: 0,
            word: ""

  @valid_keys ~w[Q W E R T Y U I O P A S D F G H J K L Ç Z X C V B N M]

  def new(word) do
    __struct__(word: String.upcase(word))
  end

  def add_key_attempted(%{state: state} = game) when state != :playing, do: game

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

  def confirm_attempt(%{state: state} = game) when state != :playing, do: game

  def confirm_attempt(game) do
    if row_is_completed?(game.keys_attempted) do
      new_state = update_state(game)

      update_game(game, %{
        keys_attempted: "",
        state: new_state,
        row_index: update_row_index(game, new_state)
      })
    else
      game
    end
  end

  defp add_last_key(game, key_attempted) do
    game.keys_attempted <> key_attempted
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
    List.replace_at(game.attempts, game.row_index, new_keys_attempted)
  end

  defp update_row_index(game, new_state) do
    case new_state do
      :playing -> game.row_index + 1
      _ -> game.row_index
    end
  end

  defp update_state(game) do
    cond do
      Enum.any?(game.attempts, &(&1 == game.word)) -> :win
      Enum.count(game.attempts, &(&1 != "")) == 6 -> :lose
      true -> :playing
    end
  end

  defp update_game(game, updated_fields) do
    Map.merge(game, updated_fields)
  end
end
