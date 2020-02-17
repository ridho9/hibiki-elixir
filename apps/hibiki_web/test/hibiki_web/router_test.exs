defmodule HibikiWeb.RouterTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias HibikiWeb.Router

  @opts Router.init([])

  test "main page" do
    conn = conn(:get, "/")

    conn = Router.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "Server is running"
  end
end
