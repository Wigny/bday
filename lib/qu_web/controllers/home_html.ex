defmodule QuWeb.HomeHTML do
  use QuWeb, :html

  def index(assigns) do
    ~H"""
    <p class="font-shark">
      Hello world!
    </p>
    """
  end
end
