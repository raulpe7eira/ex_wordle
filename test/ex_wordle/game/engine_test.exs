defmodule ExWordle.Game.EngineTest do
  use ExUnit.Case

  alias ExWordle.Game

  describe "new/1" do
    test "it will initialize the game with default state" do
      assert %Game{
               attempts: ["", "", "", "", "", ""],
               keys_attempted: "",
               state: :playing,
               row: 0,
               word: "WINNE"
             } = Game.Engine.new("WINNE")
    end
  end

  describe "add_key_attempted/2" do
    test "it adds the key attempted" do
      new_game = setup_new_game()

      assert {:ok, game} = Game.Engine.add_key_attempted(new_game, "K")

      assert game.attempts == ["K", "", "", "", "", ""]
      assert game.keys_attempted == "K"
      assert game.state == :playing
      assert game.row == 0
    end

    test "it adds the key attempted to the correct attempt" do
      new_game =
        setup_new_game(%{
          attempts: ["KAIAK", "K", "", "", "", ""],
          row: 1,
          keys_attempted: "K"
        })

      assert {:ok, game} = Game.Engine.add_key_attempted(new_game, "O")

      assert game.attempts == ["KAIAK", "KO", "", "", "", ""]
      assert game.keys_attempted == "KO"
      assert game.state == :playing
      assert game.row == 1
    end

    test "it does not add the key attempted when the key is invalid" do
      new_game = setup_new_game()

      assert {:error, :invalid_attempt} = Game.Engine.add_key_attempted(new_game, "/")
    end

    test "it does not add key attempted when the row is completed" do
      new_game =
        setup_new_game(%{
          attempts: ["KAIAK", "", "", "", "", ""],
          keys_attempted: "KAIAK"
        })

      assert {:error, :invalid_attempt} = Game.Engine.add_key_attempted(new_game, "O")
    end

    test "it does not add key attempted when the game state is not playing" do
      new_game =
        setup_new_game(%{
          attempts: ["KAIAK", "", "", "", "", ""],
          keys_attempted: "",
          state: :win,
          word: "KAIAK"
        })

      assert {:error, :game_already_over} = Game.Engine.add_key_attempted(new_game, "O")
    end
  end

  describe "remove_key_attempted/1" do
    test "removes key attempted from the keys attempted for the active row" do
      new_game =
        setup_new_game(%{
          attempts: ["KAIAK", "", "", "", "", ""],
          keys_attempted: "KAIAK"
        })

      assert {:ok, game} = Game.Engine.remove_key_attempted(new_game)

      assert game.attempts == ["KAIA", "", "", "", "", ""]
      assert game.keys_attempted == "KAIA"
      assert game.state == :playing
      assert game.row == 0
    end

    test "it does not remove anything when keys attempted is empty" do
      new_game = setup_new_game()

      assert {:error, :no_keys_attempted} = Game.Engine.remove_key_attempted(new_game)
    end

    test "it does not remove anything when the game state is not playing" do
      new_game =
        setup_new_game(%{
          attempts: ["KAIAK", "", "", "", "", ""],
          keys_attempted: "",
          state: :win,
          word: "KAIAK"
        })

      assert {:error, :game_already_over} = Game.Engine.remove_key_attempted(new_game)
    end
  end

  describe "confirm_attempts/1" do
    test "it will move all next key attempts to the next row" do
      new_game =
        setup_new_game(%{
          attempts: ["KAIAK", "", "", "", "", ""],
          keys_attempted: "KAIAK"
        })

      assert {:ok, game} = Game.Engine.confirm_attempts(new_game)

      assert game.attempts == ["KAIAK", "", "", "", "", ""]
      assert game.keys_attempted == ""
      assert game.state == :playing
      assert game.row == 1
    end

    test "it does not confirm when there're less than 5 keys in the row" do
      new_game =
        setup_new_game(%{
          attempts: ["KAIA", "", "", "", "", ""],
          keys_attempted: "KAIA"
        })

      assert {:error, :not_enough_keys_attempted} = Game.Engine.confirm_attempts(new_game)
    end

    test "it loses the game when not find the keys in all attempts" do
      new_game =
        setup_new_game(%{
          attempts: ["KAIAK", "PLACE", "BIKES", "TRICK", "YOURS", "ROUTE"],
          keys_attempted: "ROUTE",
          row: 6
        })

      assert {:ok, game} = Game.Engine.confirm_attempts(new_game)

      assert game.attempts == ["KAIAK", "PLACE", "BIKES", "TRICK", "YOURS", "ROUTE"]
      assert game.keys_attempted == ""
      assert game.state == :lose
      assert game.row == 6
    end

    test "it wins the game when finds all the keys in one attempt" do
      new_game =
        setup_new_game(%{
          attempts: ["KAIAK", "PLACE", "GREAT", "", "", ""],
          keys_attempted: "GREAT",
          row: 3
        })

      assert {:ok, game} = Game.Engine.confirm_attempts(new_game)

      assert game.attempts == ["KAIAK", "PLACE", "GREAT", "", "", ""]
      assert game.keys_attempted == ""
      assert game.state == :win
      assert game.row == 3
    end

    test "it does not confirm when the game state is not playing" do
      new_game =
        setup_new_game(%{
          attempts: ["KAIAK", "", "", "", "", ""],
          keys_attempted: "",
          state: :win,
          word: "KAIAK"
        })

      assert {:error, :game_already_over} = Game.Engine.confirm_attempts(new_game)
    end
  end

  describe "key_attempted_state/3" do
    test "when given a key attempted and position, returns the state" do
      new_game = setup_new_game()

      assert Game.Engine.key_attempted_state(new_game, "G", 0) == :found_in_position
      assert Game.Engine.key_attempted_state(new_game, "G", 2) == :found
      assert Game.Engine.key_attempted_state(new_game, "O", 0) == :not_found
    end
  end

  defp setup_new_game(attrs \\ %{}) do
    new_game = Game.Engine.new("GREAT")
    Map.merge(new_game, attrs)
  end
end
