defmodule Hibiki.Command.CallTest do
  use ExUnit.Case
  alias Hibiki.Command.Call
  doctest Call

  test "normal" do
    args = ""
    expect = {:reply, %LineSdk.Model.TextMessage{text: "Hello calling"}}
    assert Call.handle(args) == expect
  end
end
