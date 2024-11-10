defmodule Qu.Queue do
  defstruct value: :queue.new()

  def new do
    %__MODULE__{}
  end

  def to_list(%__MODULE__{value: q}) do
    :queue.to_list(q)
  end

  def member?(%__MODULE__{value: q}, item) do
    :queue.member(item, q)
  end

  def length(%__MODULE__{value: q}) do
    :queue.len(q)
  end

  def push(%__MODULE__{value: q} = queue, item) do
    %{queue | value: :queue.in(item, q)}
  end

  def pop(%__MODULE__{value: q} = queue) do
    {result, q} = :queue.out(q)
    {result, %{queue | value: q}}
  end

  defimpl Enumerable do
    def member?(queue, element) do
      {:ok, @for.member?(queue, element)}
    end

    def count(queue) do
      {:ok, @for.length(queue)}
    end

    def reduce(_queue, {:halt, acc}, _fun) do
      {:halted, acc}
    end

    def reduce(queue, {:suspend, acc}, fun) do
      {:suspended, acc, &reduce(queue, &1, fun)}
    end

    def reduce(queue, {:cont, acc}, fun) do
      case @for.pop(queue) do
        {{:value, item}, queue} -> reduce(queue, fun.(item, acc), fun)
        {:empty, _queue} -> {:done, acc}
      end
    end

    def slice(queue) do
      {:ok, @for.length(queue), &@for.to_list/1}
    end
  end
end
