defmodule Hibiki.Repo do
  use Ecto.Repo,
    otp_app: :hibiki,
    adapter: Ecto.Adapters.Postgres
end
