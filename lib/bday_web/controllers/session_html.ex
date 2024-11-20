defmodule BdayWeb.SessionHTML do
  use BdayWeb, :html

  def new(assigns) do
    ~H"""
    <div class={[
      "bg-[url('/images/cat.webp'),_url('/images/cloud-pink.webp'),_url('/images/cloud-pink.webp'),_url('/images/cloud-white.webp')]",
      "bg-[position:center_bottom,_center_-340px,_center_450px,_center_130%]",
      "bg-[length:clamp(200px,_100%,_500px),_1500px,_1500px,_1000px]",
      "bg-no-repeat",
      "px-4"
    ]}>
      <div class={[
        "bg-[url('/images/ballon.svg')]",
        "bg-[position:left_10vh]",
        "bg-[length:_100px]",
        "bg-no-repeat",
        "h-dvh overflow-hidden",
        "mx-auto max-w-xl container"
      ]}>
        <div class="flex flex-col justify-center items-center gap-2 mt-[25vh]">
          <h2 class="font-sans text-3xl text-blossom text-center uppercase">Bem-vindo</h2>
          <.title>
            Micha's Bday!
          </.title>
          <.form
            :let={f}
            for={@conn.params["user"]}
            as={:user}
            action={~p"/session"}
            class="flex flex-col justify-center gap-4"
          >
            <input
              id={f[:name].id}
              name={f[:name].name}
              type="text"
              autocomplete="name"
              required
              placeholder="Nickname"
              class="bg-mauve px-5 border-none rounded-full focus:ring-0 text-ivory placeholder:text-ivory uppercase"
            />
            <div class="flex justify-center">
              <.button type="submit">
                Entrar
              </.button>
            </div>
          </.form>
        </div>
      </div>
    </div>
    """
  end
end
