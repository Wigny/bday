defmodule BdayWeb.Components do
  use Phoenix.Component

  def title(assigns) do
    ~H"""
    <h1 class="[text-shadow:_1px_4px_0px_#f8dcdd] text-4xl text-blossom text-center [-webkit-text-stroke:1px_#693045] uppercase">
      <%= render_slot(@inner_block) %>
    </h1>
    """
  end

  attr :type, :string, values: ~w[submit button], default: "button"
  attr :rest, :global, include: ~w[disabled]
  slot :inner_block, required: true

  def button(assigns) do
    ~H"""
    <button
      class="border-2 border-mauve px-12 py-1 rounded-full text-blossom uppercase"
      type={@type}
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </button>
    """
  end
end
