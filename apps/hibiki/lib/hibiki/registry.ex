defmodule Hibiki.Registry do
  alias Hibiki.Command, as: Cmd

  def all,
    do: [
      Cmd.Call,
      Cmd.Calc,
      Cmd.Chs,
      Cmd.Help,
      Cmd.Case,
      Cmd.Info,
      Cmd.Code
    ]
end
