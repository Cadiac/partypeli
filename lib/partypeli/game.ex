defmodule Partypeli.Game do
  @moduledoc """
  Game server
  """
  use GenServer
  require Logger

  alias Partypeli.Game.Player

  defstruct [
    id: nil,
    players: %{}
    max_players: 8
  ]

  # API

  def start_link(id) do
    GenServer.start_link(__MODULE__, id, name: ref(id))
  end

  @doc """
  Called when a player joins the game
  """
  def player_connected(id, player_id, username, pid), do: try_call(id, {:player_connected, player_id, username, pid})

  @doc """
  Called when a player leaves the game
  TODO: How is this called?
  """
  def player_disconnected(id, player_id), do: try_call(id, {:player_disconnected, player_id})

  @doc """
  Returns the game's state
  """
  def get_data(id), do: try_call(id, :get_data)

  @doc """
  Returns the game's state for a given player. This could hide part of the state for the player.
  """
  def get_data(id, player_id), do: try_call(id, {:get_data, player_id})

  # SERVER

  def init(id) do
    Partypeli.Game.EventManager.game_created

    {:ok, %__MODULE__{id: id}}
  end

  def handle_call(:get_data, _from, game), do: {:reply, game, game}
  def handle_call({:get_data, player_id}, _from, game) do
    Logger.debug "Handling :get_data for player #{player_id} in Game #{game.id}"

    {:reply, game, game}
  end

  def handle_call({:player_connected, player_id, username, pid}, _from, game) do
    Logger.debug "Handling :join for #{player_id} in Game #{game.id}"

    cond do
      Map.has_key?(game.players, player_id) ->
        {:reply, {:ok, self()}, game}
      true ->
        Process.flag(:trap_exit, true)
        Process.monitor(pid)

        player = Player.create(player_id, username)

        game = add_player(game, player_id)
        Partypeli.Game.EventManager.player_connected(game.id, player)

        {:reply, {:ok, self()}, game}
    end
  end

  def handle_call({:player_disconnected, player_id}, _from, game) do
    Logger.debug "Handling :player_disconnected for #{player_id} in Game #{game.id}"

    game = remove_player(game, player_id)

    Partypeli.Game.EventManager.player_disconnected(game.id)

    {:reply, {:ok, game}, game}
  end

  @doc """
  Handles exit messages from linked game channels and boards processes
  stopping the game process.
  """
  def handle_info({:DOWN, _ref, :process, _pid, _reason} = message, game) do
    Logger.debug "Handling message in Game #{game.id}"
    Logger.debug "#{inspect message}"

    {:stop, :normal, game}
  end

  # def handle_info({:EXIT, _pid, {:shutdown, :closed}}, game) do
  #   Logger.debug "Handling :EXIT message in Game server"
  #
  #   stop(game)
  # end

  def terminate(_reason, game) do
    Logger.debug "Terminating Game process #{game.id}"

    :ok
  end

  # Generates global reference
  defp ref(id), do: {:global, {:game, id}}

  defp add_player(%__MODULE__{players: players} = game, %Player{} = player), do: %{game | players: Map.put(players, player.id, player)}

  defp remove_player(%__MODULE__{players: players} = game, player_id), do: %{game | players: Map.delete(players, player_id)}

  defp try_call(id, message) do
    case GenServer.whereis(ref(id)) do
      nil ->
        {:error, "Game does not exist"}
      game ->
        GenServer.call(game, message)
    end
  end
end
