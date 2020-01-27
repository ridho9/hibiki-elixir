defmodule HibikiWeb.Server do
  use Raxx.SimpleServer

  @impl Raxx.SimpleServer
  def handle_request(%{method: :GET}, _state) do
    response(:ok)
    |> set_header("content-type", "text/plain")
    |> set_body("hibiki is running")
  end

  def handle_request(%{method: :POST, body: body, headers: headers}, _state) do
    response(:ok)
    |> set_header("content-type", "text/plain")
    |> set_body("this is server")
  end
end
