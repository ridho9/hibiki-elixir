defmodule Hibiki.Lib.Token do
  @spec tokenize(string :: String.t()) :: [String.t()]
  def tokenize(""), do: []

  def tokenize(string) do
    {token, rest} = next_token(string)
    [token | tokenize(rest)]
  end

  @spec next_token(string :: String.t()) ::
          {token :: String.t(), rest :: String.t()}
  def next_token(""), do: {"", ""}

  def next_token(string) do
    string = String.trim_leading(string)

    cond do
      String.at(string, 0) in [~s("), ~s('), ~s(`)] ->
        q = String.at(string, 0)
        pattern = ~r/^#{q}(.*)#{q}\s*(.*)/s

        [token, rest] = Regex.run(pattern, string, capture: :all_but_first)
        {token, rest}

      true ->
        string
        |> String.split([" ", "\n", "\t"], parts: 2)
        |> case do
          [token] -> {token, ""}
          [token, rest] -> {token, rest}
        end
    end
  end
end
