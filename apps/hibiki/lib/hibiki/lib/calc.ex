defmodule Hibiki.Calc do
  use Tesla, only: [:post], docs: false

  plug(Tesla.Middleware.BaseUrl, "https://web2.0calc.com")
  plug(Tesla.Middleware.FormUrlencoded)

  def calculate(query) do
    data = %{trig: "deg", s: 0, p: 0, "in[]": query}

    headers = []

    with {:ok, %Tesla.Env{status: 200, body: body}} <- post("/calc", data, headers),
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
