defmodule Teitoku.Command.Parser do
  alias Teitoku.Command.Arguments
  alias Teitoku.Token

  @spec parse(String.t(), Arguments.t()) :: {:ok, map()} | {:error, String.t()}
  def parse(text, options) do
    with {:ok, result} <- parse_inner(String.trim(text), options) do
      result_keys = Map.keys(result)

      # apply flag default value
      result_opt =
        Enum.reduce(options.flag, result, fn flag, map ->
          if flag in result_keys do
            map
          else
            Map.put(map, flag, false)
          end
        end)
        |> Enum.map(fn {key, value} ->
          {Map.get(options.name, key, key), value}
        end)
        |> Map.new()

      {:ok, result_opt}
    end
  end

  def parse_inner("", %Arguments{named: []}) do
    {:ok, %{}}
  end

  def parse_inner("", %Arguments{named: [arg], allow_empty: true}) do
    {:ok, %{arg => ""}}
  end

  def parse_inner("", %Arguments{named: [arg | _]}) do
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
        [] ->
          {:ok, %{}}

        [arg] ->
          text = String.trim(text)

          text =
            if opt.tokenize_last do
              Token.tokenize(text)
            else
              if String.starts_with?(text, ~W(" ' `")) do
                {token, _} = Token.next_token(text)
                token
              else
                text
              end
            end

          result = %{arg => text}
          {:ok, result}

        [arg_head | arg_rest] ->
          with {:ok, rest_result} <- parse_inner(rest, %{opt | named: arg_rest}) do
            result = rest_result |> Map.put(arg_head, token)
            {:ok, result}
          end
      end
    end
  end
end
