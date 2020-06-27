defmodule Hibiki.Registry do
  alias Hibiki.Command, as: Cmd

  def subcommands,
    do: [
      Cmd.Call,
      Cmd.Calc,
      Cmd.Chs,
      Cmd.Help,
      Cmd.Case,
      Cmd.Info,
      Cmd.Upload,
      Cmd.Tag,
      Cmd.Code
    ]
end
