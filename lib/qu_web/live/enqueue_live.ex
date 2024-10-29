defmodule QuWeb.EnqueueLive do
  use QuWeb, :live_view

  on_mount {QuWeb.UserLiveAuth, :ensure_authenticated}

  @impl true
  def render(assigns) do
    ~H"""
    <span :if={is_nil(@position)}>
      <.button phx-click="join_list">Join list</.button>
    </span>
    <span :if={@position}>
      You are the in the <%= @position + 1 %>º position
    </span>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Phoenix.PubSub.subscribe(Qu.PubSub, "queue")
    end

    {:ok, assign_position(socket)}
  end

  @impl true
  def handle_event("join_list", _params, socket) do
    :ok = Qu.Queue.push(socket.assigns.current_user)
    {:noreply, assign_position(socket)}
  end

  @impl true
  def handle_info(:update, socket) do
    {:noreply, assign_position(socket)}
  end

  defp assign_position(socket) do
    assign(socket, :position, Qu.Queue.index(socket.assigns.current_user))
  end
end
