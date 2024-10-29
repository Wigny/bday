defmodule QuWeb.EnqueueLive do
  use QuWeb, :live_view

  defmodule Data do
    use Ecto.Schema
    import Ecto.Changeset

    @primary_key false
    embedded_schema do
      field :name, :string
    end

    def changeset(data \\ %__MODULE__{}, attrs) do
      data
      |> cast(attrs, [:name])
      |> validate_required([:name])
      |> validate_change(:name, fn :name, name ->
        if Qu.Queue.member?(name) do
          [name: "already enqueued"]
        else
          []
        end
      end)
    end

    def save(changeset) do
      with {:ok, data} <- apply_action(changeset, :insert),
           :ok <- Qu.Queue.push(data.name),
           do: {:ok, data}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.simple_form for={@form} phx-change="validate" phx-submit="save">
      <.input type="text" field={@form[:name]} label="Name" phx-debounce />

      <:actions>
        <.button phx-disable-with="Saving...">Submit</.button>
      </:actions>
    </.simple_form>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    data = %Data{}
    changeset = Data.changeset(data, %{})

    {:ok,
     socket
     |> assign(:data, data)
     |> assign(:form, to_form(changeset))}
  end

  @impl true
  def handle_event("validate", %{"data" => data_params}, socket) do
    changeset = Data.changeset(socket.assigns.data, data_params)
    {:noreply, assign(socket, :form, to_form(%{changeset | action: :validate}))}
  end

  def handle_event("save", %{"data" => data_params}, socket) do
    changeset = Data.changeset(socket.assigns.data, data_params)

    case Data.save(changeset) do
      {:ok, _data} -> {:noreply, put_flash(socket, :info, "User enqueued")}
      {:error, changeset} -> {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end
end
