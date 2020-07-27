defmodule Hibiki.Sauce do
  alias Hibiki.Sauce.Provider

  def all_provider,
    do: [
      Provider.Saucenao,
      Provider.Yandex
    ]

  def sauce(provider, image_url) do
    provider.sauce(image_url)
  end

  def sauce_by_code(code, image_url) do
    provider =
      all_provider()
      |> Enum.find(fn x -> x.code == code end)

    case provider do
      nil -> {:error, "Can't find provider for '#{code}'"}
      provider -> sauce(provider, image_url)
    end
  end

  def sauce_all_provider(image_url) do
    all_provider()
    |> Enum.map(fn p -> p.sauce(image_url) end)
  end
end
