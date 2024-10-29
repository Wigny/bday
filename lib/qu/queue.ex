defmodule Qu.Queue do
  use Agent

  def start_link(_args \\ []) do
    Agent.start_link(fn -> :queue.new() end, name: __MODULE__)
  end

  def push(item) do
    Agent.update(__MODULE__, &:queue.in(item, &1))
  end

  def pop do
    Agent.get_and_update(__MODULE__, fn queue ->
      case :queue.out(queue) do
        {{:value, item}, queue} -> {item, queue}
        {:empty, queue} -> {nil, queue}
      end
    end)
  end
end
