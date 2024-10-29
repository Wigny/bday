defmodule QuWeb.Router do
  use QuWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {QuWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", QuWeb do
    pipe_through :browser

    get "/", PageController, :home
    live "/enqueue", EnqueueLive
    live "/list", ListLive
  end
end
