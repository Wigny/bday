defmodule BdayWeb.HomeHTML do
  use BdayWeb, :html

  def index(assigns) do
    ~H"""
    <p class="font-shark">
      Hello world!
    </p>
    """
  end
end
