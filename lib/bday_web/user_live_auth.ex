defmodule BdayWeb.UserLiveAuth do
  use BdayWeb, :verified_routes

  import Phoenix.Component
  import Phoenix.LiveView

  def on_mount(:ensure_admin, _params, _session, socket) do
    peer_data = get_connect_info(socket, :peer_data)

    if match?({127, 0, 0, 1}, peer_data.address) do
      {:cont, socket}
    else
      {:halt, redirect(socket, to: ~p"/")}
    end
  end

  def on_mount(:ensure_authenticated, _params, %{"username" => username}, socket) do
    {:cont, assign_new(socket, :current_user, fn -> Bday.User.new(username) end)}
  end

  def on_mount(:ensure_authenticated, _params, _session, socket) do
    {:halt, redirect(socket, to: ~p"/session/new")}
  end
end
