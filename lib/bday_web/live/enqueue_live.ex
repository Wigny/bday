defmodule BdayWeb.EnqueueLive do
  use BdayWeb, :live_view

  alias Bday.QueueState

  on_mount {BdayWeb.UserLiveAuth, :ensure_authenticated}

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex flex-col gap-4 mx-auto py-4 max-w-sm h-dvh container">
      <h1 class="[text-shadow:_1px_4px_0px_#f8dcdd] text-4xl text-blossom text-center [-webkit-text-stroke:1px_#693045] uppercase">
        Fila de espera
      </h1>
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

      <button
        :if={@admin?}
        class="border-2 border-mauve mx-2 px-12 py-1 rounded-full text-blossom uppercase"
        phx-click="next"
        disabled={@queue_length == 0}
      >
        Ir para o próximo
      </button>
      <button
        :if={not @admin? and not @enqueued?}
        class="border-2 border-mauve mx-2 px-12 py-1 rounded-full text-blossom uppercase"
        phx-click="join"
      >
        Entrar na fila
      </button>
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
     |> update_assigns()}
  end

  @impl true
  def handle_event("next", _params, socket) do
    Bday.QueueState.pop()
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

  defp update_assigns(socket, queue \\ QueueState.get()) do
    user = socket.assigns.current_user
    admin = Application.fetch_env!(:bday, :admin)

    socket
    |> assign(:admin?, user.name == admin)
    |> assign(:enqueued?, QueueState.member?(user))
    |> assign(:queue_length, QueueState.length())
    |> stream(:queue, queue, reset: true)
  end
end
