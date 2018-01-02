defmodule PartypeliWeb.GameChannel do
  @moduledoc """
  Game channel
  """

  use Phoenix.Channel
  alias Partypeli.{Game}
  alias Partypeli.Game.Supervisor, as: GameSupervisor
  require Logger

  def join("game:" <> game_id, _message, socket) do
    Logger.debug "Joining Game channel #{game_id}", game_id: game_id

    player_id = socket.assigns.player_id

    case Game.player_connected(game_id, player_id, socket.channel_pid) do
      {:ok, pid} ->
        Process.monitor(pid)

        {:ok, assign(socket, :game_id, game_id)}
      {:error, reason} ->
        {:error, %{reason: reason}}
    end
  end

  def handle_in("game:joined", _message, socket) do
    Logger.debug "Broadcasting player joined #{socket.assigns.game_id}"

    player_id = socket.assigns.player_id

    broadcast!(socket, "game:player_joined", %{player_id: player_id})
    {:noreply, socket}
  end

  def handle_in("game:get_data", _message, socket) do
    game_id = socket.assigns.game_id

    data = Game.get_data(game_id)

    {:reply, {:ok, %{game: data}}, socket}
  end

  def handle_in("game:send_message", %{"text" => text}, socket) do
    Logger.debug "Handling send_message on GameChannel #{socket.assigns.game_id}"

    player_id = socket.assigns.player_id
    message = %{player_id: player_id, text: text}

    broadcast! socket, "game:message_sent", %{message: message}

    {:noreply, socket}
  end

  def terminate(reason, socket) do
    Logger.debug"Terminating GameChannel #{socket.assigns.game_id} #{inspect reason}"

    player_id = socket.assigns.player_id
    game_id = socket.assigns.game_id

    case Game.player_disconnected(game_id, player_id) do
      {:ok, game} ->

        GameSupervisor.stop_game(game_id)

        broadcast(socket, "game:player_disconnected", %{player_id: player_id})

        :ok
      _ ->
        :ok
    end
  end

  def handle_info(_, socket), do: {:noreply, socket}

  def broadcast_stop(game_id) do
    Logger.debug "Broadcasting game:stopped from GameChannel #{game_id}"

    PartypeliWeb.Endpoint.broadcast("game:#{game_id}", "game:stopped", %{})
  end
end
