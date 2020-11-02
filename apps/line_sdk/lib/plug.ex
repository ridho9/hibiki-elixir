defmodule LineSdk.Plug do
  use Plug.Builder
  use Plug.ErrorHandler
  import Plug.Conn
  require Logger

  plug(Plug.Parsers,
    parsers: [:json],
    body_reader: {__MODULE__, :cache_body, []},
    json_decoder: Jason
  )

  plug(:validate, builder_opts())
  plug(:process, builder_opts())

  def validate(
        %Plug.Conn{
          assigns: %{raw_body: raw_body}
        } = conn,
        opts
      ) do
    with {:ok, signature} <- get_signature(conn),
         IO.inspect("sign #{signature} body #{raw_body} cs #{opts[:channel_secret]}"),
         {:ok, _} <-
           LineSdk.Auth.validate_message(
             raw_body,
             opts[:channel_secret],
             signature
           ) do
      conn
    else
      {:error, err} ->
        conn
        |> send_resp(400, "#{err}")
        |> halt
    end
  end

  def process(%Plug.Conn{body_params: body} = conn, opts) do
    with {:ok, body} <- LineSdk.Decoder.decode(body),
         {:ok, _} <- opts[:handler].handle(conn, body) do
      conn
      |> send_resp(200, 'OK')
    else
      {:error, err} ->
        conn |> send_resp(500, "#{err}")
    end
  end

  def handle_errors(conn, %{kind: kind, reason: reason, stack: stack}) do
    Logger.error("Plug error #{inspect(kind)} - #{inspect(reason)} - #{inspect(stack)}")

    send_resp(conn, conn.status, "Something went wrong")
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
