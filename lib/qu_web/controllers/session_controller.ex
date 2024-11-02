defmodule QuWeb.SessionController do
  use QuWeb, :controller

  plug :redirect_if_logged

  def new(conn, _params) do
    render(conn, :new)
  end

  def create(conn, %{"user" => %{"name" => username}}) do
    conn
    |> put_session(:username, username)
    |> redirect(to: ~p"/")
  end

  defp redirect_if_logged(conn, _opts) do
    if get_session(conn, :username) do
      conn
      |> redirect(to: ~p"/")
      |> halt()
    else
      conn
    end
  end
end
