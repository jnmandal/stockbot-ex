defmodule Stockbot.MessageHandler do
  @moduledoc """
  the message handler for our bot
  """
  require Logger

  alias Stockbot.MessageQueue

  # @name __MODULE__

  def start_link(opts \\ []) do
    Task.start_link(__MODULE__, :fetch_message, opts)
  end

  def fetch_message() do
    MessageQueue.dequeue_message()
    |> handle_dequeue()

    fetch_message()
  end

  private do
    defp handle_dequeue({:ok, message}) do
      IO.inspect(message)
    end

    defp handle_dequeue({:error, :empty}) do
    end

    defp handle_message() do
    end
    defp handle_message() do
    end

  end
end
