defmodule RonQuotesWeb.Router do
  use RonQuotesWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    # plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RonQuotesWeb do
    pipe_through :browser

    # get "/", PageController, :index
    get "/quote/", QuoteController, :get_quote
    get "/quote/:size", QuoteController, :get_quote_of_size
    post "/quote/rate/:rating", QuoteController, :add_quote_rating
  end

  # Other scopes may use custom stacks.
  # scope "/api", RonQuotesWeb do
  #   pipe_through :api
  # end
end
