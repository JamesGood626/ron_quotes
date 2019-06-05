defmodule RonQuotes.QuoteSupervisor do
  use Supervisor
  alias RonQuotes.QuoteServer

  def start_link(_options) do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children = [
      QuoteServer
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
