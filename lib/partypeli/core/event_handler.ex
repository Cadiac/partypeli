defmodule Partypeli.Game.EventHandler do
  use GenEvent
  alias PartypeliWeb.LobbyChannel

  def handle_event(:game_created, state), do: broadcast_update(state)
  def handle_event(:player_connected, state), do: broadcast_update(state)
  def handle_event(_, state), do: {:ok, state}

  defp broadcast_update(state) do
    LobbyChannel.broadcast_current_games

    {:ok, state}
  end
end
