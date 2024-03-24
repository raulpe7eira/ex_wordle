defmodule ExWordle.GameEngineTest do
  use ExUnit.Case

  alias ExWordle.GameEngine

  describe "new/o" do
    test "it will initialize the game with default state" do
      assert %GameEngine{
               attempts: ["", "", "", "", "", ""],
               keys_attempted: "",
               state: :playing,
               row_index: 0,
               correct_word: ""
             } = GameEngine.new()
    end
  end

  describe "add_key_attempted/2" do
    test "it adds the key attempted" do
      new_game = game_fixture()
      game = GameEngine.add_key_attempted(new_game, "K")

      assert game.keys_attempted == "K"
      assert game.attempts == ["K", "", "", "", "", ""]
    end

    test "it adds the key attempted to the correct attempt" do
      new_game =
        game_fixture(%{
          attempts: ["KAFKA", "K", "", "", "", ""],
          row_index: 1,
          keys_attempted: "K"
        })

      game = GameEngine.add_key_attempted(new_game, "O")

      assert game.keys_attempted == "KO"
      assert game.attempts == ["KAFKA", "KO", "", "", "", ""]
    end

    test "it does not add the key attempted when the key is invalid" do
      new_game = game_fixture()
      game = GameEngine.add_key_attempted(new_game, "/")

      assert game.keys_attempted == ""
      assert game.attempts == ["", "", "", "", "", ""]
    end

    test "it does not add key attempted when the row is completed" do
      new_game =
        game_fixture(%{
          attempts: ["KAFKA", "", "", "", "", ""],
          row_index: 0,
          keys_attempted: "KAFKA"
        })

      game = GameEngine.add_key_attempted(new_game, "O")

      assert game.keys_attempted == "KAFKA"
      assert game.attempts == ["KAFKA", "", "", "", "", ""]
    end
  end

  defp game_fixture(attrs \\ %{}) do
    new_game = GameEngine.new()
    Map.merge(new_game, attrs)
  end
end
