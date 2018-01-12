defmodule Partypeli.Game.EventHandler do
  use GenServer
  require Logger
  alias PartypeliWeb.LobbyChannel
  alias PartypeliWeb.GameChannel

  def handle_cast({:game_stopped, game_id}, state) do
    GameChannel.broadcast_stop(game_id)
    {:noreply, state}
  end

  def handle_cast({:player_connected, {game_id, player}}, state) do
    GameChannel.broadcast_player_connected(game_id, player)
    {:noreply, state}
  end

  def handle_cast({:player_disconnected, game_id}, state) do
    GameChannel.broadcast_stop(game_id)
    {:noreply, state}
  end

  def handle_cast(:game_created, state), do: broadcast_channel(state)

  def handle_cast(event, state) do
    Logger.warn "EventHandler: Unmatched event #{event}"

    {:noreply, state}
  end

  defp broadcast_channel(state) do
    LobbyChannel.broadcast_current_games

    {:noreply, state}
  end
end
