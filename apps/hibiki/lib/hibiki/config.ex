defmodule Hibiki.Config do
  def channel_access_token, do: Application.fetch_env!(:hibiki, :channel_access_token)
  def channel_secret, do: Application.fetch_env!(:hibiki, :channel_secret)

  def admin_id, do: Application.fetch_env!(:hibiki, :admin_id)

  def client,
    do: %LineSdk.Client{
      channel_access_token: channel_access_token(),
      channel_secret: channel_secret()
    }

  def deepl_proxy, do: Application.fetch_env!(:hibiki, :deepl_proxy)
end
