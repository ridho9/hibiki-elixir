defmodule Teitoku.Command.OptionsTest do
  use ExUnit.Case
  alias Teitoku.Command.Options
  doctest Options

  test "add named" do
    input = %Options{} |> Options.add_named("arg1")

    expect = %Options{named: ["arg1"]}
    assert input == expect
  end

  test "add flag" do
    input = %Options{} |> Options.add_flag("flag")

    expect = %Options{flag: ["flag"]}
    assert input == expect
  end

  test "allow empty" do
    input = %Options{} |> Options.allow_empty()

    expect = %Options{allow_empty: true}
    assert input == expect
  end

  test "add name" do
    input = %Options{} |> Options.add_named("arg1", name: "argument")

    expect = %Options{named: ["arg1"], name: %{"arg1" => "argument"}}
    assert input == expect
  end
end
