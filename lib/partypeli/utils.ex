defmodule Partypeli.Utils do
  @moduledoc """
  Game utils
  """

  @doc """
  Generates unique id for the game
  """
  def generate_game_id(length \\ 4) do
    :crypto.strong_rand_bytes(length)
    |> Base.url_encode64
    |> binary_part(0, length)
  end
end
