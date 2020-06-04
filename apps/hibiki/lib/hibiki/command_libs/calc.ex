defmodule Hibiki.Calc do
  def calculate(query) do
    data = [trig: "deg", s: 0, p: 0, "in[]": query]

    url = "https://web2.0calc.com/calc"
    headers = []

    with data = {:form, data},
         {:ok, %HTTPoison.Response{status_code: 200, body: body}} <-
           HTTPoison.post(url, data, headers),
         {:ok, %{"results" => [result | _]}} <- Jason.decode(body),
         %{"status" => status} = result do
      if status == "ok" do
        {:ok, result}
      else
        {:error, status}
      end
    end
  end
end
