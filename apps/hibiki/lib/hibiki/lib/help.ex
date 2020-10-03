defmodule Hibiki.Help do
  alias Teitoku.Command.Options, as: Opt

  @spec gen_usage(module(), list(module())) :: String.t()
  def gen_usage(command, parent) do
    cmds =
      [command | parent]
      |> Enum.map(fn x -> x.name end)
      |> Enum.reverse()
      |> Enum.join(" ")

    res = "Usage: !" <> cmds <> " "

    opt = command.options
    flags = opt.flag

    res =
      res <>
        if Enum.empty?(flags) do
          ""
        else
          "[..flags] "
        end <> gen_usage_named(opt)

    res
  end

  def gen_flag_desc(command) do
    if command.options.flag |> Enum.empty?() do
      ""
    else
      [
        "Flags:"
        | Enum.map(command.options.flag, fn flag ->
            if flag in command.options.hidden do
              ""
            else
              "  -#{flag}: " <> Map.get(command.options.desc, flag, flag)
            end
          end)
      ]
      |> Enum.filter(fn x -> x != "" end)
      |> Enum.join("\n")
    end
  end

  def gen_usage_desc(command) do
    if command.options.named |> Enum.empty?() do
      ""
    else
      [
        "Named:"
        | Enum.map(command.options.named, fn named ->
            "  #{named}: " <> Map.get(command.options.desc, named, named)
          end)
      ]
      |> Enum.join("\n")
    end
  end

  def gen_subcommands(command) do
    if command.subcommands() == [] do
      ""
    else
      "Subcommands: " <>
        (command.subcommands() |> Enum.map(fn x -> x.name() end) |> Enum.join(", "))
    end
  end

  @spec gen_usage_named(Teitoku.Command.Options.t()) :: String.t()
  def gen_usage_named(%Opt{named: []}), do: ""

  def gen_usage_named(%Opt{named: [name], allow_empty: allow_empty}) do
    if allow_empty do
      "[#{name}] "
    else
      "<#{name}> "
    end
  end

  def gen_usage_named(%Opt{named: [n | ns]} = opt),
    do: "<#{n}>" <> gen_usage_named(%{opt | named: ns})
end
