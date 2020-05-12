defmodule Hibiki.Lib.Command.Registry do
  alias Hibiki.Command
  alias Hibiki.Lib

  def all,
    do: [
      Command.Call
    ]

  def resolve_text(text) do
    {name, rest} =
      Lib.Token.next_token(text)
      |> IO.inspect()

    Enum.find(all(), fn cmd -> cmd.name == name end)
    |> case do
      nil -> {:error, "command #{name} not found"}
      cmd -> {:ok, cmd, rest}
    end
  end
end
