defmodule HibikiWeb.Server do
  use Raxx.SimpleServer

  @impl Raxx.SimpleServer
  def handle_request(%{method: :GET}, _state) do
    response(:ok)
    |> set_header("content-type", "text/plain")
    |> set_body("hibiki is running")
  end

  def handle_request(%{method: :POST, body: body} = req, _state) do
    signature = Raxx.get_header(req, "x-line-signature")

    Hibiki.Parser.parse_webhook_message(body, signature)
    |> IO.inspect()

    response(:ok)
    |> set_header("content-type", "text/plain")
    |> set_body("this is server")
  end
end
