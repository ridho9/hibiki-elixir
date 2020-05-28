defmodule Hibiki.Command do
  @callback name() :: String.t()
  @callback handle(any) :: Hibiki.Event.result()
end
