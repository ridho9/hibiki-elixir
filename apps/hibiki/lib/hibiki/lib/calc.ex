defmodule Hibiki.Calc do
  def calculate(query) do
    data = [trig: "deg", s: 0, p: 0, "in[]": query]

    url = "https://web2.0calc.com/calc"
    headers = []
    data = {:form, data}

    with {:ok, %HTTPoison.Response{status_code: 200, body: body}} <-
           HTTPoison.post(url, data, headers),
         {:ok, %{"results" => [result | _]}} <- Jason.decode(body) do
      %{"status" => status} = result

      if status == "ok" do
        {:ok, result}
      else
        {:error, status}
      end
    end
  end
end
