defmodule HibikiWeb.Plug.Hibiki do
  use Plug.Builder
  import Plug.Conn

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["text/*"],
    body_reader: {HibikiWeb.Plug.Hibiki, :cache_body, []},
    json_decoder: Jason
  )

  plug(:process)

  def process(conn, _opts) do
    conn
    |> IO.inspect()
    |> send_resp(200, "Process")
  end

  def cache_body(conn, opts) do
    {:ok, body, conn} = read_body(conn, opts)
    conn = update_in(conn.assigns[:raw_body], &[body | &1 || []])
    {:ok, body, conn}
  end
end
