defmodule Hibiki.Registry do
  alias Hibiki.Command, as: Cmd

  def all,
    do: [
      Cmd.Call,
      Cmd.Calc,
      Cmd.Chs,
      Cmd.Help
    ]
end
