defmodule Hibiki.Converter do
  def convert(event, ctx \\ %{}) do
    Hibiki.Convertable.convert(event, ctx)
  end
end

defprotocol Hibiki.Convertable do
  @spec convert(any, map) :: {:ok, any, map} | {:error, any}
  def convert(event, ctx)

  @fallback_to_any true
end

defimpl Hibiki.Convertable, for: Any do
  def convert(obj, ctx), do: {:error, {obj, ctx}}
end
