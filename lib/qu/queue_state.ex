defmodule Qu.QueueState do
  use Agent
  alias Qu.Queue

  def start_link(_args \\ []) do
    Agent.start_link(fn -> Queue.new() end, name: __MODULE__)
  end

  def get do
    Agent.get(__MODULE__, & &1)
  end

  def member?(user) do
    Agent.get(__MODULE__, &Queue.member?(&1, user))
  end

  def push(user) do
    Agent.update(__MODULE__, &Queue.push(&1, user))
    notify_change()

    :ok
  end

  def pop do
    {:value, user} = Agent.get_and_update(__MODULE__, &Queue.pop/1)
    notify_change()

    user
  end

  defp notify_change do
    Phoenix.PubSub.broadcast!(Qu.PubSub, "queue", {:change, get()})
  end
end
