defmodule Teitoku.Command.Registry do
  alias Teitoku.Token
  alias Teitoku.Command.Parser

  @spec resolve_text(String.t(), module()) :: {:ok, module(), String.t()} | {:error, String.t()}
  def resolve_text(text, registry) do
    {name, rest} = Token.next_token(text)

    Enum.find(registry.all(), fn cmd -> cmd.name == name end)
    |> case do
      nil -> {:error, "command '#{name}' not found"}
      cmd -> {:ok, cmd, rest}
    end
  end

  def prepare(text, registry) do
    with {:ok, command, text} <- resolve_text(text, registry),
         {:ok, args} <- Parser.parse(text, command.options()) do
      {:ok, command, args}
    end
  end
end
