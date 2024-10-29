defmodule QuWeb.SessionHTML do
  use QuWeb, :html

  def new(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.header class="text-center">
        Log in
      </.header>

      <.simple_form :let={f} for={@conn.params["user"]} as={:user} action={~p"/session"}>
        <.input field={f[:name]} type="text" autocomplete="name" label="Name" required />

        <:actions>
          <.button phx-disable-with="Logging in..." class="w-full">
            Log in <span aria-hidden="true">→</span>
          </.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end
end
