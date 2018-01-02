defmodule Partypeli.Game.Event do
  def start_link do
    {:ok, manager} = GenEvent.start_link(name: __MODULE__)

    handlers = [
      Partypeli.Game.EventHandler
    ]

    Enum.each(handlers, &GenEvent.add_handler(manager, &1, []))

    {:ok, manager}
  end

  def game_created, do: GenEvent.notify(__MODULE__, :game_created)
  def player_connected, do: GenEvent.notify(__MODULE__, :player_connected)
  def player_disconnected, do: GenEvent.notify(__MODULE__, :player_disconnected)
end
