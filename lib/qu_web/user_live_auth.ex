defmodule QuWeb.UserLiveAuth do
  use QuWeb, :verified_routes

  import Phoenix.Component
  import Phoenix.LiveView

  def on_mount(:ensure_admin, _params, _session, socket) do
    {:cont, socket}
  end

  def on_mount(:ensure_authenticated, _params, %{"username" => username}, socket) do
    {:cont, assign_new(socket, :current_user, fn -> Qu.User.new(username) end)}
  end

  def on_mount(:ensure_authenticated, _params, _session, socket) do
    {:halt, redirect(socket, to: ~p"/session/new")}
  end
end
