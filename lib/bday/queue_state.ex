defmodule Bday.QueueState do
  use Agent
  alias Bday.Queue

  def start_link(_args \\ []) do
    Agent.start_link(fn -> Queue.new() end, name: __MODULE__)
  end

  def get do
    Agent.get(__MODULE__, & &1)
  end

  def length do
    Agent.get(__MODULE__, &Queue.length/1)
  end

  def member?(item) do
    Agent.get(__MODULE__, &Queue.member?(&1, item))
  end

  def push(item) do
    :ok = Agent.update(__MODULE__, &Queue.push(&1, item))
    notify_change()

    :ok
  end

  def pop do
    {:value, item} = Agent.get_and_update(__MODULE__, &Queue.pop/1)
    notify_change()

    item
  end

  defp notify_change do
    Phoenix.PubSub.broadcast!(Bday.PubSub, "queue", {:change, get()})
  end
end
