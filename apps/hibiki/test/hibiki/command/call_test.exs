defmodule Hibiki.Command.CallTest do
  use ExUnit.Case
  alias Hibiki.Command.Call
  doctest Call

  test "normal" do
    args = ""

    expect =
      {:reply,
       %LineSdk.Model.TextMessage{
         text: "Roger, Hibiki, heading out!\n\nI'll never forget Tenshi..."
       }}

    assert Call.handle(args, nil) == expect
  end
end
