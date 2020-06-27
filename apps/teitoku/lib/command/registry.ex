defmodule Teitoku.Command.Registry do
  alias Teitoku.Token
  alias Teitoku.Command.Parser

  @spec resolve_command(module(), String.t()) ::
          {:ok, module(), String.t(), list(module)} | {:error, any()}
  def resolve_command(registry, text) do
    resolve_inner(registry, text, [])
    |> case do
      {^registry, _, _} ->
        {name, _} = Token.next_token(text)
        {:error, "command '#{name}' not found"}

      {command, text, parent} ->
        {:ok, command, text, parent |> Enum.filter(fn x -> x != registry end)}
    end
  end

  def resolve_inner(cur_cmd, text, parent) do
    if cur_cmd.subcommands() == [] or text == "" do
      {cur_cmd, text, parent}
    else
      {name, rest} = Token.next_token(text)

      Enum.find(cur_cmd.subcommands(), fn cmd -> cmd.name == name end)
      |> case do
        nil -> {cur_cmd, text, parent}
        cmd -> resolve_inner(cmd, rest, [cur_cmd | parent])
      end
    end
  end

  def prepare(text, registry) do
    with {:ok, command, text, _} <- resolve_command(registry, text),
         {:ok, args} <- Parser.parse(text, command.options()) do
      {:ok, command, args}
    end
  end
end
