defmodule Partypeli.Game.Player do
  @moduledoc """
  Game server
  """
  use GenServer
  require Logger

  defstruct [
    id: nil,
    username: "",
    connected: true,
    ready: false
  ]

  @doc """
  Creates a new Player with given ID and username.
  """
  def create(player_id, username) do
    %__MODULE__{id: player_id, username: username}
  end
end
