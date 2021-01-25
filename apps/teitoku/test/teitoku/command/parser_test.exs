defmodule Teitoku.Command.ParserTest do
  use ExUnit.Case
  alias Teitoku.Command.Parser
  alias Teitoku.Command.Arguments

  doctest Parser

  test "parse 0" do
    input = ""
    option = %Arguments{}

    result = Parser.parse(input, option)
    expect = {:ok, %{}}

    assert result == expect
  end

  test "parse 1" do
    input = "aaaa"
    option = %Arguments{} |> Arguments.add_named("arg1")

    result = Parser.parse(input, option)
    expect = {:ok, %{"arg1" => "aaaa"}}

    assert result == expect
  end

  test "parse 2" do
    input = ""
    option = %Arguments{} |> Arguments.add_named("arg1")

    result = Parser.parse(input, option)
    expect = {:error, "missing argument 'arg1'"}

    assert result == expect
  end

  test "parse 3" do
    input = "aaaa bbbb"
    option = %Arguments{} |> Arguments.add_named("arg1")

    result = Parser.parse(input, option)
    expect = {:ok, %{"arg1" => input}}

    assert result == expect
  end

  test "parse 4" do
    input = "aaaa bbbb"
    option = %Arguments{} |> Arguments.add_named("arg1") |> Arguments.add_named("arg2")

    result = Parser.parse(input, option)
    expect = {:ok, %{"arg1" => "aaaa", "arg2" => "bbbb"}}

    assert result == expect
  end

  test "parse 5" do
    input = "aaaa bbbb  cccc"

    option =
      %Arguments{}
      |> Arguments.add_named("arg1")
      |> Arguments.add_named("arg2")
      |> Arguments.add_named("arg3")

    result = Parser.parse(input, option)
    expect = {:ok, %{"arg1" => "aaaa", "arg2" => "bbbb", "arg3" => "cccc"}}

    assert result == expect
  end

  test "parse flag 1" do
    input = ""

    options =
      %Arguments{}
      |> Arguments.add_flag("flag1")

    expect = {:ok, %{"flag1" => false}}
    assert Parser.parse(input, options) == expect
  end

  test "parse flag 2" do
    input = "-flag1"

    options =
      %Arguments{}
      |> Arguments.add_flag("flag1")

    expect = {:ok, %{"flag1" => true}}
    assert Parser.parse(input, options) == expect
  end

  test "parse 6" do
    input = "-flag1 aaaa"

    options =
      %Arguments{}
      |> Arguments.add_flag("flag1")
      |> Arguments.add_named("arg1")

    expect = {:ok, %{"flag1" => true, "arg1" => "aaaa"}}
    assert Parser.parse(input, options) == expect
  end

  test "parse 7" do
    input = "aaaa"

    options =
      %Arguments{}
      |> Arguments.add_flag("flag1")
      |> Arguments.add_named("arg1")

    expect = {:ok, %{"flag1" => false, "arg1" => "aaaa"}}
    assert Parser.parse(input, options) == expect
  end

  test "parse allow empty 1" do
    input = ""

    options =
      %Arguments{}
      |> Arguments.add_named("arg1")
      |> Arguments.allow_empty()

    expect = {:ok, %{"arg1" => ""}}
    assert Parser.parse(input, options) == expect
  end

  test "parse allow empty 2" do
    input = "aaaa"

    options =
      %Arguments{}
      |> Arguments.add_named("arg1")
      |> Arguments.add_named("arg2")
      |> Arguments.allow_empty()

    expect = {:ok, %{"arg1" => "aaaa", "arg2" => ""}}
    assert Parser.parse(input, options) == expect
  end

  test "parse name mapping 1" do
    input = ""

    options =
      %Arguments{}
      |> Arguments.add_named("arg1", name: "argument")
      |> Arguments.allow_empty()

    expect = {:ok, %{"argument" => ""}}
    assert Parser.parse(input, options) == expect
  end

  test "parse rest 1" do
    input = "aaaa bbbb cccc"

    option =
      %Arguments{}
      |> Arguments.add_named("arg1")
      |> Arguments.add_named("arg2")

    result = Parser.parse(input, option)
    expect = {:ok, %{"arg1" => "aaaa", "arg2" => "bbbb cccc"}}

    assert result == expect
  end

  test "parse rest 2" do
    input = ~s(aaaa "")

    option =
      %Arguments{}
      |> Arguments.add_named("arg1")
      |> Arguments.add_named("arg2")

    result = Parser.parse(input, option)
    expect = {:ok, %{"arg1" => "aaaa", "arg2" => ""}}

    assert result == expect
  end

  test "parse rest 3" do
    input = ~s(aaaa "a b c ")

    option =
      %Arguments{}
      |> Arguments.add_named("arg1")
      |> Arguments.add_named("arg2")

    result = Parser.parse(input, option)
    expect = {:ok, %{"arg1" => "aaaa", "arg2" => "a b c "}}

    assert result == expect
  end
end
