defmodule Bday.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {DNSCluster, query: Application.get_env(:bday, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Bday.PubSub},
      Bday.QueueState,
      BdayWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: Bday.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    BdayWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
