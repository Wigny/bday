defmodule BdayWeb.SessionHTML do
  use BdayWeb, :html

  def new(assigns) do
    ~H"""
    <div class={[
      "bg-[url('/images/cloud-pink.webp'),_url('/images/cloud-pink.webp'),_url('/images/cloud-white.webp')]",
      "bg-[position:center_-340px,_center_450px,_center_130%]",
      "bg-[length:1500px,_1500px,_1000px]",
      "bg-no-repeat",
      "px-4"
    ]}>
      <div class={[
        "bg-[url('/images/ballon.svg'),_url('/images/cat.webp')]",
        "bg-[position:left_15vh,_center_bottom]",
        "bg-[length:_100px,_clamp(200px,_100%,_500px)]",
        "bg-no-repeat",
        "h-dvh overflow-hidden",
        "mx-auto max-w-xl container"
      ]}>
        <div class="flex flex-col justify-center items-center gap-2 mt-[25vh]">
          <h2 class="font-sans text-3xl text-blossom text-center uppercase">Bem-vindo</h2>
          <h1 class="[text-shadow:_1px_4px_0px_#f8dcdd] text-6xl text-blossom text-center [-webkit-text-stroke:1px_#693045] uppercase">
            Micha's Bday!
          </h1>
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
              <button
                type="submit"
                class="border-2 border-mauve px-12 py-1 rounded-full text-blossom uppercase"
              >
                Entrar
              </button>
            </div>
          </.form>
        </div>
      </div>
    </div>
    """
  end
end
