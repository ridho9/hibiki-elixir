defmodule LineSdkTest do
  use ExUnit.Case
  doctest LineSdk

  test "greets the world" do
    assert LineSdk.hello() == :world
  end
end
