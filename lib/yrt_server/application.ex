defmodule YrtServer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      YrtServerWeb.Telemetry,
      YrtServer.Repo,
      {DNSCluster, query: Application.get_env(:yrt_server, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: YrtServer.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: YrtServer.Finch},
      # Start a worker by calling: YrtServer.Worker.start_link(arg)
      # {YrtServer.Worker, arg},
      # Start to serve requests, typically the last entry
      YrtServerWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: YrtServer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    YrtServerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
