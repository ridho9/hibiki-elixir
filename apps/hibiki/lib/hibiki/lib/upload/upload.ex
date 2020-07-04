defmodule Hibiki.Upload do
  alias Hibiki.Upload.Provider.Catbox
  alias Hibiki.Cache

  @spec upload_binary(module, binary) :: {:ok, String.t()} | {:error, any}
  def upload_binary(provider, binary) do
    provider.upload_binary(binary)
  end

  @spec upload_base64_to_catbox(String.t()) :: {:ok, String.t()} | {:error, any}
  def upload_base64_to_catbox(string) do
    with {:ok, binary} <- Base.decode64(string) do
      Catbox.upload_binary(binary)
    end
  end

  def upload_from_image_id(provider, image_id) do
    cache_key = Cache.Key.uploaded_image_url(image_id, provider.id)

    case Cache.get(cache_key) do
      nil ->
        with {:ok, image_binary} <- LineSdk.Client.get_content(Hibiki.Config.client(), image_id),
             {:ok, image_url} <- upload_binary(provider, image_binary) do
          Cache.set(cache_key, image_url)
          {:ok, image_url}
        end

      image_url ->
        {:ok, image_url}
    end
  end
end
