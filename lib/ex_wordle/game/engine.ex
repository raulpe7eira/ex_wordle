defmodule ExWordle.Game.Engine do
  alias ExWordle.Game

  alias ExWordle.Constants

  @max_attempts 6
  @max_keys_attempted 5
  @valid_keys ~w[Q W E R T Y U I O P A S D F G H J K L Ç Z X C V B N M]

  def new(word), do: Game.new(word)

  def add_key_attempted(%{state: state}, _key_attempted) when state != :playing,
    do: {:error, :game_already_over}

  def add_key_attempted(game, key_attempted) do
    key_attempted = String.upcase(key_attempted)

    if invalid_attempt?(game.keys_attempted, key_attempted) do
      {:error, :invalid_attempt}
    else
      new_keys_attempted = add_last_key(game, key_attempted)

      game =
        Game.update(game, %{
          attempts: update_attempts(game, new_keys_attempted),
          keys_attempted: new_keys_attempted
        })

      {:ok, game}
    end
  end

  def remove_key_attempted(%{state: state}) when state != :playing,
    do: {:error, :game_already_over}

  def remove_key_attempted(game) do
    if row_is_empty?(game.keys_attempted) do
      {:error, :no_keys_attempted}
    else
      new_keys_attempted = remove_last_key(game)

      game =
        Game.update(game, %{
          attempts: update_attempts(game, new_keys_attempted),
          keys_attempted: new_keys_attempted
        })

      {:ok, game}
    end
  end

  def confirm_attempts(%{state: state}) when state != :playing,
    do: {:error, :game_already_over}

  def confirm_attempts(game) do
    cond do
      not max_keys_attempted?(game.keys_attempted) ->
        {:error, :not_enough_keys_attempted}

      invalid_guesses?(game.keys_attempted) ->
        {:error, :invalid_guesses}

      true ->
        new_state = update_state(game)

        game =
          Game.update(game, %{
            keys_attempted: "",
            keys_attempted_state: update_keys_attempted_state(game),
            state: new_state,
            row: update_row(game, new_state)
          })

        {:ok, game}
    end
  end

  def key_attempted_state(game, key_attempted, position) do
    cond do
      found_key_attempted_in_position?(game, key_attempted, position) -> :found_in_position
      found_key_attempted?(game, key_attempted) -> :found
      true -> :not_found
    end
  end

  defp add_last_key(game, key_attempted) do
    game.keys_attempted <> key_attempted
  end

  defp found_key_attempted?(game, key_attempted) do
    key_attempted in String.graphemes(game.word)
  end

  defp found_key_attempted_in_position?(game, key_attempted, position) do
    key_attempted == String.at(game.word, position)
  end

  defp has_no_other_attempt?(attempts) do
    Enum.count(attempts, &(&1 != "")) == @max_attempts
  end

  defp has_win_attempt?(attempts, word) do
    Enum.any?(attempts, &(&1 == word))
  end

  defp invalid_attempt?(keys_attempted, key_attempted) do
    max_keys_attempted?(keys_attempted) or invalid_key?(key_attempted)
  end

  defp invalid_guesses?(keys_attempted) do
    String.downcase(keys_attempted) not in Constants.words()
  end

  defp invalid_key?(key_attempted) do
    key_attempted not in @valid_keys
  end

  defp max_keys_attempted?(keys_attempted) do
    String.length(keys_attempted) == @max_keys_attempted
  end

  defp remove_last_key(game) do
    keys_attempted_length = String.length(game.keys_attempted)
    String.slice(game.keys_attempted, 0, keys_attempted_length - 1)
  end

  defp row_is_empty?(keys_attempted) do
    String.length(keys_attempted) <= 0
  end

  defp update_attempts(game, new_keys_attempted) do
    List.replace_at(game.attempts, game.row, new_keys_attempted)
  end

  defp update_keys_attempted_state(game) do
    game.keys_attempted
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.reduce(game.keys_attempted_state, fn {key_attempted, position}, acc ->
      game
      |> key_attempted_state(key_attempted, position)
      |> case do
        :found_in_position ->
          Map.put(acc, key_attempted, :found_in_position)

        :found ->
          Map.update(acc, key_attempted, :found, fn value ->
            if value == :found_in_position, do: value, else: :found
          end)

        :not_found ->
          Map.put_new(acc, key_attempted, :not_found)
      end
    end)
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
end
