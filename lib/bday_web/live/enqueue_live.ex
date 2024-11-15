defmodule BdayWeb.EnqueueLive do
  use BdayWeb, :live_view

  on_mount {BdayWeb.UserLiveAuth, :ensure_authenticated}

  @impl true
  def render(assigns) do
    ~H"""
    <h1 class="font-shark text-6xl text-[#693045]">Fila de espera</h1>

    <ul id="queue" phx-update="stream" class="grid grid-cols-1 gap-y-5 pb-40">
      <li :for={{dom_id, user} <- @streams.queue} id={dom_id}>
        <.guest_card
          nickname={user.name}
          index={Bday.QueueState.position(user) + 1}
          is_my={Bday.QueueState.position(user) == @position}
        />
      </li>
    </ul>

    <div :if={is_nil(@position)} class="fixed bottom-0 left-0 bg-white w-full p-4 grid grid-cols-1">
      <.button phx-click="join_list">Join list</.button>
    </div>
    <%!-- <span :if={@position}>
      You are the in the <%= @position + 1 %>º position
    </span> --%>

    <img
      src={~p"/images/bandeirolas-rosinha.svg"}
      alt=""
      class="absolute -top-10 -right-5  w-3/4 blur-sm -z-10"
    />
    <img
      src={~p"/images/bandeirolas-roxa.svg"}
      alt=""
      class="absolute top-32 -left-10  w-3/4 blur-sm -z-10"
    />
    <img
      src={~p"/images/bandeirolas-rosinha.svg"}
      alt=""
      class="absolute top-2/3 -right-5 -left-0 blur-sm -z-10"
    />
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Phoenix.PubSub.subscribe(Bday.PubSub, "queue")
    end

    {:ok,
     socket
     |> stream_configure(:queue, dom_id: &"user-#{&1.name}")
     |> update_queue(Bday.QueueState.get())}
  end

  @impl true
  def handle_event("join_list", _params, socket) do
    user = socket.assigns.current_user
    Bday.QueueState.push(user)
    {:noreply, stream_insert(socket, :queue, user, limit: -10)}
  end

  @impl true
  def handle_info({:change, queue}, socket) do
    {:noreply, update_queue(socket, queue)}
  end

  defp update_queue(socket, queue) do
    socket
    |> stream(:queue, Enum.take(queue, 10), reset: true)
    |> assign(:position, Enum.find_index(queue, &(&1 == socket.assigns.current_user)))
  end
end
