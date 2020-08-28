defmodule Hibiki do
  require Logger

  def version do
    Application.spec(:hibiki, :vsn)
  end

  def tag do
    Application.get_env(:hibiki, :tag)
  end
end
