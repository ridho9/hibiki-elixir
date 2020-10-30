defmodule Hibiki.WebhookHandler do
  def handle(_conn, body) do
    Teitoku.Event.handle(body, Hibiki.Config.client(), Hibiki.Converter)
  end
end
