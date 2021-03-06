defmodule HibikiWeb.Router do
  use Plug.Router

  plug(Plug.Logger)
  plug(:match)
  plug(:dispatch)

  get "/" do
    conn |> send_resp(200, "Server is running")
  end

  post("/hibiki",
    to: LineSdk.Plug,
    init_opts: [
      channel_secret: {Hibiki.Config, :channel_secret, []},
      handler: Hibiki.WebhookHandler
    ]
  )

  match _ do
    conn |> send_resp(404, "Oops")
  end
end
