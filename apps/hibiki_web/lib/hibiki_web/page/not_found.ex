defmodule HibikiWeb.Page.NotFound do
  use Raxx.SimpleServer

  @impl Raxx.SimpleServer
  def handle_request(_req, _state) do
    response(:not_found)
    |> set_header("content-type", "text/plain")
    |> set_body("content not found")
  end
end
