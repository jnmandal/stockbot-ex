defmodule Stockbot.MessageQueue do
  @moduledoc """
  the message queue for our bot
  """

  use GenServer

  @name MQ

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts ++ [name: @name])
  end

  def init(:ok) do
    {:ok, :queue.new()}
  end

  def read_messages() do
    GenServer.call(@name, :read)
  end

  def enqueue_message(update) do
    GenServer.cast(@name, {:enqueue, update})
  end

  def dequeue_message() do
    GenServer.call(@name, :dequeue)
  end

  def handle_call(:read, _from, queue) do
    {:reply, {:ok, queue}, queue}
  end

  def handle_call(:dequeue, _from, queue) do
    case :queue.out(queue) do
      {{:value, value}, new_queue} -> {:reply, {:ok, value}, new_queue}
      {:empty, {[], []}} -> {:reply, {:error, :empty}, queue}
    end
  end

  def handle_cast({:enqueue, update}, queue) do
    new_queue = :queue.in(update, queue)
    {:noreply, new_queue}
  end

  def handle_info(_msg, state) do
    {:noreply, state}
  end
end
