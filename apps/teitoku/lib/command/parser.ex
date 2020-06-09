defmodule Teitoku.Command.Parser do
  alias Teitoku.Command.Options
  alias Teitoku.Token

  @spec parse(String.t(), Options.t()) :: {:ok, map()} | {:error, String.t()}
  def parse(text, options) do
    with {:ok, result} <- parse_inner(String.trim(text), options) do
      result_keys = Map.keys(result)

      {:ok,
       Enum.reduce(options.flag, result, fn flag, map ->
         if flag not in result_keys do
           Map.put(map, flag, false)
         else
           map
         end
       end)}
    end
  end

  def parse_inner("", %Options{named: []}) do
    {:ok, %{}}
  end

  def parse_inner("", %Options{named: [arg]}) do
    {:error, "missing argument '#{arg}'"}
  end

  def parse_inner(text, opt) do
    {token, rest} = text |> String.trim() |> Token.next_token()

    if String.starts_with?(token, "-") do
      token = String.slice(token, 1..-1)

      with {:ok, rest_result} <- parse_inner(rest, opt) do
        result = Map.put(rest_result, token, true)
        {:ok, result}
      end
    else
      case opt.named do
        [arg] ->
          result = %{arg => String.trim(text)}
          {:ok, result}

        [arg_head | arg_rest] ->
          with {:ok, rest_result} <- parse_inner(rest, %{opt | named: arg_rest}) do
            result = rest_result |> Map.put(arg_head, token)
            {:ok, result}
          end
      end
    end
  end

  # def parse_inner(text, %Options{named: [arg]}) do
  #   result = %{arg => String.trim(text)}
  #   {:ok, result}

  #   if String.starts_with?(arg, "-") do
  #     arg = arg |> String.slice(1..-1) |> String.trim()
  #     {:ok, %{arg => true}}
  #   end
  # end

  # def parse_inner(text, %Options{named: [arg_head | arg_rest]} = opt) do
  #   {token, rest} = text |> String.trim() |> Token.next_token()

  #   with {:ok, rest_result} <- parse_inner(rest, %{opt | named: arg_rest}) do
  #     result = rest_result |> Map.put(arg_head, token)
  #     {:ok, result}
  #   end
  # end
end
