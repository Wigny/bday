defmodule BdayWeb.EnqueueLive do
  use BdayWeb, :live_view

  alias Bday.{Queue, QueueState}

  on_mount {BdayWeb.UserLiveAuth, :ensure_authenticated}

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex flex-col gap-4 mx-auto py-4 max-w-sm h-dvh container">
      <.title>
        Fila de espera
      </.title>
      <ul class="scrollbar-hidden h-full overflow-y-auto [counter-reset:user]">
        <li :for={{dom_id, user} <- @streams.queue} id={dom_id} class="[counter-increment:user]">
          <div
            class="bg-mauve m-2 p-4 rounded-2xl aria-checked:outline outline-2 outline-mauve outline-offset-2"
            aria-checked={to_string(user == @current_user)}
          >
            <h3 class="text-ivory"><%= user.name %></h3>
            <p class="after:content-[counter(user)] text-blossom uppercase">
              Posição
            </p>
          </div>
        </li>
      </ul>

      <.button :if={@user_admin?} phx-click="next" disabled={@queue_length == 0}>
        Ir para o próximo
      </.button>
      <.button :if={not @user_admin? and not @user_enqueued?} phx-click="join">
        Entrar na fila
      </.button>
    </div>
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
     |> update_assigns(QueueState.get())}
  end

  @impl true
  def handle_event("next", _params, socket) do
    QueueState.pop()
    {:noreply, socket}
  end

  def handle_event("join", _params, socket) do
    QueueState.push(socket.assigns.current_user)
    {:noreply, socket}
  end

  @impl true
  def handle_info({:change, queue}, socket) do
    {:noreply, update_assigns(socket, queue)}
  end

  defp update_assigns(socket, queue) do
    user = socket.assigns.current_user
    admin = Application.fetch_env!(:bday, :admin)

    socket
    |> assign(:user_admin?, user.name == admin)
    |> assign(:user_enqueued?, Queue.member?(queue, user))
    |> assign(:queue_length, Queue.length(queue))
    |> stream(:queue, queue, reset: true)
  end
end
