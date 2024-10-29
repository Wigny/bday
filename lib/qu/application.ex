defmodule Qu.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Phoenix.PubSub, name: Qu.PubSub},
      Qu.Queue,
      QuWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: Qu.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    QuWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
