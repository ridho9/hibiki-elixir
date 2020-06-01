defmodule Hibiki.Lib.Command.Registry do
  alias Hibiki.Command
  alias Hibiki.Token

  @spec all() :: [module()]
  def all,
    do: [
      Command.Call
    ]

  @spec resolve_text(String.t()) :: {:ok, module(), String.t()} | {:error, String.t()}
  def resolve_text(text) do
    {name, rest} =
      Token.next_token(text)
      |> IO.inspect()

    Enum.find(all(), fn cmd -> cmd.name == name end)
    |> case do
      nil -> {:error, "command #{name} not found"}
      cmd -> {:ok, cmd, rest}
    end
  end
end
