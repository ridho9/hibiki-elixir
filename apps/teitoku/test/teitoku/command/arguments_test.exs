defmodule Teitoku.Command.ArgumentsTest do
  use ExUnit.Case
  alias Teitoku.Command.Arguments
  doctest Arguments

  test "add named" do
    input = %Arguments{} |> Arguments.add_named("arg1")

    expect = %Arguments{named: ["arg1"]}
    assert input == expect
  end

  test "add flag" do
    input = %Arguments{} |> Arguments.add_flag("flag")

    expect = %Arguments{flag: ["flag"]}
    assert input == expect
  end

  test "allow empty" do
    input = %Arguments{} |> Arguments.allow_empty()

    expect = %Arguments{allow_empty: true}
    assert input == expect
  end

  test "add name" do
    input = %Arguments{} |> Arguments.add_named("arg1", name: "argument")

    expect = %Arguments{named: ["arg1"], name: %{"arg1" => "argument"}}
    assert input == expect
  end
end
