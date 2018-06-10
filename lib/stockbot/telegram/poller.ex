defmodule Stockbot.Telegram.Poller do
  @moduledoc """
  Polls telegram and enqueues those messages
  Keeps the current message offfset as its state
  """

  use GenServer
  use Private

  alias Stockbot.MessageQueue

  @name TGP

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts ++ [name: @name])
  end

  def init(:ok) do
    poll()
    {:ok, -1}
  end

  def poll() do
    GenServer.cast(@name, :poll)
  end

  def handle_cast(:poll, offset) do
    new_offset = Nadia.get_updates(offset: offset, timeout: 2)
    |> handle_updates()

    {:noreply, new_offset || offset, 1}
  end

  def handle_info(:timeout, offset) do
    poll()
    {:noreply, offset}
  end

  private do
    # happy path
    defp handle_updates({:ok, []}) do
      nil
    end
    defp handle_updates({:ok, updates}) do
      enqueue_messages(updates)
    end
    defp handle_updates({:error, %{reason: :timeout}}) do
      nil
    end

    # sad path
    defp handle_updates(unknown) do
      IO.puts("Unknown updates response #{inspect unknown}")
      nil
    end

    defp enqueue_messages([message | messages]) do
      id = enqueue_message(message)
      enqueue_messages(messages) || id + 1
    end
    defp enqueue_messages([]), do: nil

    defp enqueue_message(%{update_id: update_id} = message) do
      MessageQueue.enqueue_message(message)
      update_id
    end
  end
end
