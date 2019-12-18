defmodule Server do
  use Raxx.SimpleServer

  import Raxx

  @impl Raxx.SimpleServer
  def handle_request(%{method: :GET, path: []}, _state) do
    response(:ok)
    |> set_body("Hello!")
  end

  def handle_request(_request, _state) do
    response(:not_found)
    |> set_body("not found")
  end
end
