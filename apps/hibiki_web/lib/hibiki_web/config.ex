defmodule HibikiWeb.Config do
  def channel_secret, do: Application.get_env(:hibiki, :channel_secret)
end
