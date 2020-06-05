defmodule Teitoku.Command.Parser do
  alias Teitoku.Command.Options
  alias Teitoku.Token

  @spec parse(String.t(), Options.t()) :: {:ok, map()} | {:error, String.t()}
  def parse(text, options) do
    parse_inner(String.trim(text), options)
  end

  def parse_inner("", %Options{named: []}) do
    {:ok, %{}}
  end

  def parse_inner("", %Options{named: [arg]}) do
    {:error, "missing argument '#{arg}'"}
  end

  def parse_inner(text, %Options{named: [arg]}) do
    result = %{arg => String.trim(text)}
    {:ok, result}
  end

  def parse_inner(text, %Options{named: [arg_head | arg_rest]} = opt) do
    {token, rest} = text |> String.trim() |> Token.next_token()

    with {:ok, rest_result} <- parse_inner(rest, %{opt | named: arg_rest}) do
      result = rest_result |> Map.put(arg_head, token)
      {:ok, result}
    end
  end
end
