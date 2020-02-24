defmodule LineSdk.Config do
  def channel_access_token() do
    Application.get_env(:line_sdk, :channel_access_token)
  end

  def channel_secret() do
    Application.get_env(:line_sdk, :channel_secret)
  end
end
