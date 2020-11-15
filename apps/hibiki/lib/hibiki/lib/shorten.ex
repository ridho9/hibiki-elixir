defmodule Hibiki.Shorten do
  @url "https://s.kryk.io"

  def shorten(target) do
    url = @url <> "/api/create"

    with {:ok, body} <- Jason.encode(%{"url" => target}),
         {:ok, %HTTPoison.Response{status_code: 201, body: body}} <-
           HTTPoison.post(url, body, [{"content-type", "application/json"}], []),
         {:ok, %{"result" => result}} <- Jason.decode(body) do
      {:ok, "#{@url}/#{result}"}
    end
  end

  def shorten!(target) do
    case shorten(target) do
      {:ok, url} -> url
      {:error, err} -> raise err
    end
  end
end
