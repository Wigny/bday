defmodule Qu.User do
  defstruct ~w[name]a

  def new(username) do
    struct!(__MODULE__, name: username)
  end
end
