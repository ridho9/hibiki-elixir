defmodule Hibiki.Cache do
  use GenServer
  require Logger

  ## Client API

  def start_link(opts) do
    GenServer.start_link(__MODULE__, [], opts)
  end

  @spec set(any, any) :: :ok | {:error, any}
  def set(key, value) do
    GenServer.call(__MODULE__, {:set, {key, value}})
  end

  @spec get(any) :: any
  def get(key) do
    GenServer.call(__MODULE__, {:get, {key}})
  end

  ## Server Callback

  def init(_args) do
    Logger.info("Initializing Hibiki.Cache")

    table = :ets.new(:hibiki_cache, [:set])
    {:ok, {table}}
  end

  def handle_call({:set, {key, value}}, _from, {table}) do
    res = :ets.insert(table, {key, value})
    {:reply, res, {table}}
  end

  def handle_call({:get, {key}}, _from, {table}) do
    case :ets.lookup(table, key) do
      [] -> {:reply, nil, {table}}
      [{^key, result}] -> {:reply, result, {table}}
    end
  end

  # def terminate(_reason, {table}) do
  #   Logger.info("Terminating Hibiki.Cache")
  #   :dets.close(table)
  # end
end

defmodule Hibiki.Cache.Key do
  def uploaded_image_url(image_id, provider_id), do: {:uploaded_image_url, image_id, provider_id}
end
