defmodule Teitoku.TokenTest do
  use ExUnit.Case
  alias Teitoku.Token
  doctest Teitoku.Token

  test "next token empty string" do
    string = ""
    expect = {"", ""}
    assert Token.next_token(string) == expect
  end

  test "next token one string" do
    string = "aaa"
    expect = {"aaa", ""}
    assert Token.next_token(string) == expect
  end

  test "next token two string" do
    string = "aaa bbb"
    expect = {"aaa", "bbb"}
    assert Token.next_token(string) == expect
  end

  test "next token two string leading space" do
    string = "   aaa bbb"
    expect = {"aaa", "bbb"}
    assert Token.next_token(string) == expect
  end

  test "next token two string space betweeen" do
    string = "aaa  bbb "
    expect = {"aaa", " bbb "}
    assert Token.next_token(string) == expect
  end

  test "next token two string newline" do
    string = ~s(aaa\nbbb)
    expect = {"aaa", "bbb"}
    assert Token.next_token(string) == expect
  end

  test "next token two string quote" do
    string = ~s("aaa" bbb)
    expect = {~s(aaa), ~s(bbb)}
    assert Token.next_token(string) == expect
  end

  test "next token two string backtick" do
    string = ~s(`aaa` bbb)
    expect = {~s(aaa), ~s(bbb)}
    assert Token.next_token(string) == expect
  end

  test "test 1" do
    string = ~s("aaa" "bbb")
    expect = {~s(aaa), ~s("bbb")}
    assert Token.next_token(string) == expect
  end
end
