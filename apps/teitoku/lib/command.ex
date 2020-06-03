defmodule Teitoku.Command do
  @callback name() :: String.t()
  @callback handle(any) :: Teitoku.Event.result()
end
