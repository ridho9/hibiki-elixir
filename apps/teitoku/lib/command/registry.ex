defmodule Teitoku.Command.Registry do
  alias Teitoku.Token

  @spec resolve_text(String.t(), module()) :: {:ok, module(), String.t()} | {:error, String.t()}
  def resolve_text(text, registry) do
    {name, rest} =
      Token.next_token(text)
      |> IO.inspect()

    Enum.find(registry.all(), fn cmd -> cmd.name == name end)
    |> case do
      nil -> {:error, "command #{name} not found"}
      cmd -> {:ok, cmd, rest}
    end
  end
end
