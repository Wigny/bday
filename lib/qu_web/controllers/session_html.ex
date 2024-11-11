defmodule QuWeb.SessionHTML do
  use QuWeb, :html

  def new(assigns) do
    ~H"""
    <div class="h-full flex justify-center items-center flex-col relative">
      <img src={~p"/images/bandeirolas-roxa.svg"} alt="" class="absolute -top-10 -left-10  w-3/4" />
      <img src={~p"/images/bandeirolas-rosinha.svg"} alt="" class="absolute -top-10 -right-5  w-3/4" />

      <div class="z-10">
        <.header class="text-center font-shark uppercase text-3xl">
          Faça login para participarda lista de espera ;)
        </.header>

        <.simple_form :let={f} for={@conn.params["user"]} as={:user} action={~p"/session"}>
          <.input
            field={f[:name]}
            type="text"
            autocomplete="name"
            label="Name"
            required
            placeholder="Nickname"
            class="font-shark"
          />

          <:actions>
            <.button phx-disable-with="Logging in..." class="w-full">
              Entrar
            </.button>
          </:actions>
        </.simple_form>
      </div>

      <img
        src={~p"/images/baloes.svg"}
        alt=""
        class="fixed w-[1200px] max-w-none -bottom-40 left-1/2 -translate-x-1/2 -z-1"
      />
    </div>
    """
  end
end
