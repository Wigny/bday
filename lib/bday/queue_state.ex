defmodule Bday.QueueState do
  use Agent
  alias Bday.Queue

  def start_link(_args \\ []) do
    Agent.start_link(&init/0, name: __MODULE__)
  end

  defp init do
    {:ok, _table} =
      :dets.open_file(__MODULE__, file: ~c"/tmp/bday_queue", auto_save: to_timeout(second: 1))

    retrieve()
  end

  def get do
    Agent.get(__MODULE__, & &1)
  end

  def push(item) do
    Agent.update(__MODULE__, fn queue ->
      queue = Queue.push(queue, item)
      persist(queue)
      notify_change(queue)
      queue
    end)
  end

  def delete(item) do
    Agent.update(__MODULE__, fn queue ->
      queue = Queue.delete(queue, item)
      persist(queue)
      notify_change(queue)
      queue
    end)
  end

  def pop do
    {:value, item} =
      Agent.get_and_update(__MODULE__, fn queue ->
        {result, queue} = Queue.pop(queue)
        persist(queue)
        notify_change(queue)
        {result, queue}
      end)

    item
  end

  defp retrieve do
    case :dets.lookup(__MODULE__, :queue) do
      [{:queue, queue}] -> queue
      [] -> Queue.new()
    end
  end

  defp persist(queue) do
    :dets.insert(__MODULE__, {:queue, queue})
  end

  defp notify_change(queue) do
    Phoenix.PubSub.broadcast!(Bday.PubSub, "queue", {:change, queue})
  end
end
