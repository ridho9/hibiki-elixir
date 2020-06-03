defmodule HibikiWeb.Plug.Hibiki do
  use Plug.Builder
  import Plug.Conn

  plug(Plug.Parsers,
    parsers: [:json],
    body_reader: {HibikiWeb.Plug.Hibiki, :cache_body, []},
    json_decoder: Jason
  )

  plug(:validate)
  plug(:process)

  def validate(
        %Plug.Conn{
          assigns: %{raw_body: raw_body}
        } = conn,
        _opts
      ) do
    with {:ok, signature} <- get_signature(conn),
         {:ok, _} <- Teitoku.Validation.validate_message(raw_body, signature) do
      conn
    else
      {:error, err} ->
        conn
        |> send_resp(400, "#{err}")
        |> halt
    end
  end

  def process(%Plug.Conn{body_params: body} = conn, _opts) do
    with {:ok, body} <- LineSdk.Decoder.decode(body),
         {:ok, result} <- Teitoku.Event.webhook_handle(body) do
      IO.inspect(result)

      conn
      |> send_resp(200, "Processed")
    else
      {:error, err} ->
        conn |> send_resp(500, "#{err}")
    end
  end

  def cache_body(conn, opts) do
    {:ok, body, conn} = read_body(conn, opts)
    conn = update_in(conn.assigns[:raw_body], &[body | &1 || []])
    {:ok, body, conn}
  end

  defp get_signature(conn) do
    get_req_header(conn, "x-line-signature")
    |> case do
      [] -> {:error, "missing x-line-signature"}
      [signature] -> {:ok, signature}
    end
  end
end
