defmodule Hibiki.Server do
  use Raxx.SimpleServer
  import Raxx

  @impl Raxx.SimpleServer
  def handle_request(_req, _state) do
    response(:ok)
    |> set_header("content-type", "text/plain")
    |> set_body("hibiki")
  end
end
