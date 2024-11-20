defmodule BdayWeb.EnqueueLive do
  use BdayWeb, :live_view

  alias Bday.{Queue, QueueState, User}

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
            <div class="flex justify-between">
              <div>
                <h3 class="text-ivory"><%= user.name %></h3>
                <p class="after:content-[counter(user)] text-blossom uppercase">
                  Posição
                </p>
              </div>
              <button
                :if={user == @current_user or @user_admin?}
                phx-click="remove"
                phx-value-username={user.name}
              >
                <svg
                  viewBox="0 0 1024 1024"
                  class="w-6 h-6 text-ivory"
                  xmlns="http://www.w3.org/2000/svg"
                >
                  <path fill="currentColor" d="M352 480h320a32 32 0 110 64H352a32 32 0 010-64z" /><path
                    fill="currentColor"
                    d="M512 896a384 384 0 100-768 384 384 0 000 768zm0 64a448 448 0 110-896 448 448 0 010 896z"
                  />
                </svg>
              </button>
            </div>
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

  def handle_event("remove", %{"username" => username}, socket) do
    QueueState.delete(User.new(username))
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
