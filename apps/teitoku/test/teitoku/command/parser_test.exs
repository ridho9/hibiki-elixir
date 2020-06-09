defmodule Teitoku.Command.ParserTest do
  use ExUnit.Case
  alias Teitoku.Command.Parser
  alias Teitoku.Command.Options

  doctest Parser

  test "parse 0" do
    input = ""
    option = %Options{}

    result = Parser.parse(input, option)
    expect = {:ok, %{}}

    assert result == expect
  end

  test "parse 1" do
    input = "aaaa"
    option = %Options{} |> Options.add_named("arg1")

    result = Parser.parse(input, option)
    expect = {:ok, %{"arg1" => "aaaa"}}

    assert result == expect
  end

  test "parse 2" do
    input = ""
    option = %Options{} |> Options.add_named("arg1")

    result = Parser.parse(input, option)
    expect = {:error, "missing argument 'arg1'"}

    assert result == expect
  end

  test "parse 3" do
    input = "aaaa bbbb"
    option = %Options{} |> Options.add_named("arg1")

    result = Parser.parse(input, option)
    expect = {:ok, %{"arg1" => input}}

    assert result == expect
  end

  test "parse 4" do
    input = "aaaa bbbb"
    option = %Options{} |> Options.add_named("arg1") |> Options.add_named("arg2")

    result = Parser.parse(input, option)
    expect = {:ok, %{"arg1" => "aaaa", "arg2" => "bbbb"}}

    assert result == expect
  end

  test "parse 5" do
    input = "aaaa bbbb  cccc"

    option =
      %Options{}
      |> Options.add_named("arg1")
      |> Options.add_named("arg2")
      |> Options.add_named("arg3")

    result = Parser.parse(input, option)
    expect = {:ok, %{"arg1" => "aaaa", "arg2" => "bbbb", "arg3" => "cccc"}}

    assert result == expect
  end

  test "parse flag 1" do
    input = ""

    options =
      %Options{}
      |> Options.add_flag("flag1")

    expect = {:ok, %{"flag1" => false}}
    assert Parser.parse(input, options) == expect
  end

  test "parse flag 2" do
    input = "-flag1"

    options =
      %Options{}
      |> Options.add_flag("flag1")

    expect = {:ok, %{"flag1" => true}}
    assert Parser.parse(input, options) == expect
  end

  test "parse 6" do
    input = "-flag1 aaaa"

    options =
      %Options{}
      |> Options.add_flag("flag1")
      |> Options.add_named("arg1")

    expect = {:ok, %{"flag1" => true, "arg1" => "aaaa"}}
    assert Parser.parse(input, options) == expect
  end

  test "parse 7" do
    input = "aaaa"

    options =
      %Options{}
      |> Options.add_flag("flag1")
      |> Options.add_named("arg1")

    expect = {:ok, %{"flag1" => false, "arg1" => "aaaa"}}
    assert Parser.parse(input, options) == expect
  end
end
