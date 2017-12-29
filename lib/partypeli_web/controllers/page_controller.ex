defmodule PartypeliWeb.PageController do
  use PartypeliWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
