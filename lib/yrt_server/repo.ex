defmodule YrtServer.Repo do
  use Ecto.Repo,
    otp_app: :yrt_server,
    adapter: Ecto.Adapters.Postgres
end
