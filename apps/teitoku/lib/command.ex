defmodule Teitoku.Command do
  @callback name() :: String.t()
  @callback options() :: Teitoku.Command.Options.t()

  @callback handle(any, any) :: Teitoku.Event.result()
end
