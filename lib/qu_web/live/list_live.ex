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
     |> stream_configure(:queue, dom_id: &"user-#{&1.name}")
     |> assing_queue(Qu.Queue.get())}
  end

  @impl true
  def handle_info({:change, queue}, socket) do
    {:noreply, assing_queue(socket, queue)}
  end

  defp assing_queue(socket, queue) do
    stream(socket, :queue, queue, reset: true)
  end

  @impl true
  def handle_event("next", _params, socket) do
    Qu.Queue.pop()
    {:noreply, socket}
  end
end
