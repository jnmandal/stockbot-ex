defmodule Stockbot.Application do
  @moduledoc """
  OTP application for the stockbot

  We have a core genserver:
    - Stockbot.MessageQueue
  A statless worker:
    - Stockbot.MessageHandler
  Then an additional genserver for each message source:
    - Stockbot.Telegram.Poller
  """

  use Application
  import Supervisor.Spec, warn: false

  def start(_type, _args) do
    children = [
      # core logic
      worker(Stockbot.MessageQueue, []),
      worker(Stockbot.MessageHandler, []),
      # message sources
      worker(Stockbot.Telegram.Poller, [])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_all, name: Stockbot.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
