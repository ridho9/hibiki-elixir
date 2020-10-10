defmodule Hibiki.Cache do
  def set(key, value) do
    Cachex.put(__MODULE__, key, value, ttl: :timer.minutes(10))
  end

  def get(key) do
    Cachex.get(__MODULE__, key)
  end

  def get!(key) do
    Cachex.get!(__MODULE__, key)
  end
end

defmodule Hibiki.Cache.Key do
  def uploaded_image_url(image_id, provider_id), do: {:uploaded_image_url, image_id, provider_id}
end
