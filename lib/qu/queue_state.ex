defmodule Qu.QueueState do
  use Agent
  alias Qu.Queue

  def start_link(_args \\ []) do
    Agent.start_link(fn -> Queue.new() end, name: __MODULE__)
  end

  def get do
    Agent.get(__MODULE__, & &1)
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

  def position(item) do
    Agent.get(__MODULE__, fn queue -> Enum.find_index(queue, &(&1 == item)) end)
  end

  defp notify_change do
    Phoenix.PubSub.broadcast!(Qu.PubSub, "queue", {:change, get()})
  end
end
