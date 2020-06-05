defmodule Teitoku.Command do
  @callback name() :: String.t()
  @callback options() :: Teitoku.Command.Options.t()

  @callback handle(Teitoku.Command.Options.t(), any) :: Teitoku.Event.result()
end
