defmodule Hibiki.Converter do
  def convert(event) do
    Hibiki.Convertable.convert(event)
  end
end

defprotocol Hibiki.Convertable do
  @spec convert(any) :: {:ok, any} | {:error, any}
  def convert(object)

  @fallback_to_any true
end

defimpl Hibiki.Convertable, for: Any do
  def convert(obj), do: {:error, obj}
end
