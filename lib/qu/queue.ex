defmodule Qu.Queue do
  use Agent

  def start_link(_args \\ []) do
    Agent.start_link(fn -> :queue.new() end, name: __MODULE__)
  end

  def push(item) do
    with :ok <- Agent.update(__MODULE__, &:queue.in(item, &1)),
         :ok = Phoenix.PubSub.broadcast(Qu.PubSub, "queue", {:push, item}),
         do: :ok
  end

  def member?(item) do
    Agent.get(__MODULE__, &:queue.member(item, &1))
  end

  def pop do
    Agent.get_and_update(__MODULE__, &pop/1)
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
    |> Stream.unfold(&with({nil, _q} <- pop(&1), do: nil))
    |> Enum.take(n)
  end
end
