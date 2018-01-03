defmodule Partypeli.Game.EventHandler do
  use GenServer
  require Logger
  alias PartypeliWeb.LobbyChannel

  def handle_cast(:game_created, state), do: broadcast_update(state)
  def handle_cast(:player_connected, state), do: broadcast_update(state)
  def handle_cast(event, state) do
    Logger.warn "EventHandler: Unmatched event #{event}"
    {:noreply, state}
  end

  defp broadcast_update(state) do
    LobbyChannel.broadcast_current_games

    {:noreply, state}
  end
end
