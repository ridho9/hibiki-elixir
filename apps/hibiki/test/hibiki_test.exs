defmodule HibikiTest do
  use ExUnit.Case
  doctest Hibiki

  test "greets the world" do
    assert Hibiki.hello() == :world
  end
end
