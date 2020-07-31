defmodule Hibiki.Upload.Provider do
  @callback upload_binary(binary) :: {:ok, String.t()} | {:error, any}
  @callback id :: atom

  defmacro __using__(_opts) do
    quote do
      @behaviour Hibiki.Upload.Provider
    end
  end
end
