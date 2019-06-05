defmodule RonQuotesWeb.PageController do
  use RonQuotesWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
