defmodule QuWeb.ListLive do
  use QuWeb, :live_view

  on_mount {QuWeb.UserLiveAuth, :ensure_admin}

  @impl true
  def render(assigns) do
    ~H"""
    <div id="queue" phx-update="stream">
      <p :for={{item_id, user} <- @streams.queue} id={item_id}>
        <%= user.name %>
      </p>
    </div>
    <.button phx-click="next">Next</.button>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Phoenix.PubSub.subscribe(Qu.PubSub, "queue")
    end

    {:ok,
     socket
     |> stream_configure(:queue, dom_id: &"name-#{&1.name}")
     |> stream(:queue, Qu.Queue.peek(10))}
  end

  @impl true
  def handle_info(:update, socket) do
    {:noreply, stream(socket, :queue, Qu.Queue.peek(10), reset: true)}
  end

  @impl true
  def handle_event("next", _params, socket) do
    _item = Qu.Queue.pop()
    {:noreply, socket}
  end
end
