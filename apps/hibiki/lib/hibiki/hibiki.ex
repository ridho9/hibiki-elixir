defmodule Hibiki do
  require Logger

  def version do
    Application.spec(:hibiki, :vsn)
  end

  def tag do
    Application.fetch_env!(:hibiki, :tag)
  end
end
