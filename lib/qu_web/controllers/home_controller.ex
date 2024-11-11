defmodule QuWeb.HomeController do
  use QuWeb, :controller

  def index(conn, _params) do
    render(conn, :index)
  end
end
