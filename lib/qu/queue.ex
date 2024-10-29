defmodule Qu.Queue do
  use Agent

  def start_link(_args \\ []) do
    Agent.start_link(fn -> :queue.new() end, name: __MODULE__)
  end

  def push(item) do
    with :ok <- Agent.update(__MODULE__, &:queue.in(item, &1)),
         :ok = Phoenix.PubSub.broadcast(Qu.PubSub, "queue", :update),
         do: :ok
  end

  def delete(item) do
    Agent.update(__MODULE__, &:queue.delete(item, &1))
    Phoenix.PubSub.broadcast!(Qu.PubSub, "queue", :update)

    :ok
  end

  def member?(item) do
    Agent.get(__MODULE__, &:queue.member(item, &1))
  end

  def index(item) do
    Agent.get(__MODULE__, &index(&1, item))
  end

  def pop do
    item = Agent.get_and_update(__MODULE__, &pop/1)
    Phoenix.PubSub.broadcast!(Qu.PubSub, "queue", :update)

    item
  end

  def peek(n) do
    Agent.get(__MODULE__, &peek(&1, n))
  end

  defp pop(queue) do
    case :queue.out(queue) do
      {{:value, item}, queue} -> {item, queue}
      {:empty, queue} -> {nil, queue}
    end
  end

  defp peek(queue, n) do
    queue
    |> to_stream()
    |> Enum.take(n)
  end

  defp index(queue, item) do
    queue
    |> to_stream()
    |> Enum.find_index(&(&1 == item))
  end

  defp to_stream(queue) do
    Stream.unfold(queue, &with({nil, _queue} <- pop(&1), do: nil))
  end
end
