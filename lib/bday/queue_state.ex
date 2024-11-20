defmodule Bday.QueueState do
  use Agent
  alias Bday.Queue

  def start_link(_args \\ []) do
    Agent.start_link(fn -> Queue.new() end, name: __MODULE__)
  end

  def get do
    Agent.get(__MODULE__, & &1)
  end

  def push(item) do
    Agent.update(__MODULE__, fn queue ->
      queue = Queue.push(queue, item)
      notify_change(queue)
      queue
    end)
  end

  def pop do
    {:value, item} =
      Agent.get_and_update(__MODULE__, fn queue ->
        {result, queue} = Queue.pop(queue)
        notify_change(queue)
        {result, queue}
      end)

    item
  end

  defp notify_change(queue) do
    Phoenix.PubSub.broadcast!(Bday.PubSub, "queue", {:change, queue})
  end
end
