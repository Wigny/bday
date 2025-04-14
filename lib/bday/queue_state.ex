defmodule Bday.QueueState do
  use Task
  alias Bday.Queue

  def start_link(_args \\ []) do
    Task.start_link(&init/0)
  end

  defp init do
    {:ok, _table} =
      :dets.open_file(__MODULE__, file: ~c"/tmp/bday_queue", auto_save: to_timeout(second: 1))

    Process.hibernate(Function, :identity, [nil])
  end

  def push(item) do
    queue = Queue.push(get(), item)

    persist(queue)
    notify_change(queue)

    queue
  end

  def delete(item) do
    queue = Queue.delete(get(), item)

    persist(queue)
    notify_change(queue)

    queue
  end

  def pop do
    {item, queue} = Queue.pop(get())

    persist(queue)
    notify_change(queue)

    item
  end

  def get do
    case :dets.lookup(__MODULE__, :queue) do
      [{:queue, queue}] -> queue
      [] -> Queue.new()
    end
  end

  defp persist(queue) do
    :ok = :dets.insert(__MODULE__, {:queue, queue})
  end

  defp notify_change(queue) do
    Phoenix.PubSub.broadcast!(Bday.PubSub, "queue", {:change, queue})
  end
end
