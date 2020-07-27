defmodule Hibiki.Sauce.Provider do
  @callback code :: String.t()
  @callback sauce(image_url :: String.t()) :: String.t()
end

defmodule Hibiki.Sauce.Provider.Saucenao do
  @behaviour Hibiki.Sauce.Provider

  def code, do: "sn"

  def sauce(url) do
    url = URI.encode_www_form(url)
    "https://saucenao.com/search.php?url=#{url}"
  end
end

defmodule Hibiki.Sauce.Provider.Yandex do
  @behaviour Hibiki.Sauce.Provider

  def code, do: "yn"

  def sauce(url) do
    url = URI.encode_www_form(url)
    "https://yandex.com/images/search?source=collections&&url=#{url}&rpt=imageview"
  end
end
