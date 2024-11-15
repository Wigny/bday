defmodule BdayWeb.HomeController do
  use BdayWeb, :controller

  def index(conn, _params) do
    render(conn, :index)
  end
end
