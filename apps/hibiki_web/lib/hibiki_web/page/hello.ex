defmodule HibikiWeb.Page.Hello do
  use Raxx.SimpleServer

  @impl Raxx.SimpleServer
  def handle_request(_req, state) do
    IO.inspect(state)

    response(:ok)
    |> set_header("content-type", "text/plain")
    |> set_body("hello world")
  end
end
