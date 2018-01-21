defmodule Partypeli.Game.EventManager do
  require Logger

  @timeout 30_000

  def start_link() do
    import Supervisor.Spec
    child = worker(GenServer, [], restart: :temporary)
    {:ok, manager} = Supervisor.start_link([child], strategy: :simple_one_for_one, name: __MODULE__)

    handlers = [
      Partypeli.Game.EventHandler
    ]

    Enum.each(handlers, &add_handler(manager, &1, []))

    {:ok, manager}
  end

  def stop(sup) do
    for {_, pid, _, _} <- Supervisor.which_children(sup) do
      GenServer.stop(pid, :normal, @timeout)
    end
    Supervisor.stop(sup)
  end

  def add_handler(sup, handler, opts) do
    Supervisor.start_child(sup, [handler, opts])
  end

  defp notify(sup, msg) do
    for {_, pid, _, _} <- Supervisor.which_children(sup) do
      GenServer.cast(pid, msg)
    end
    :ok
  end

  # LobbyChannel
  def game_created, do: notify(__MODULE__, :game_created)

  # GameChannel
  def player_connected(game_id, player), do: notify(__MODULE__, {:player_connected, {game_id, player}})
  def player_disconnected(game_id, player), do: notify(__MODULE__, {:player_disconnected, {game_id, player}})
  def game_stopped(game_id), do: notify(__MODULE__, {:game_stopped, game_id})
end
