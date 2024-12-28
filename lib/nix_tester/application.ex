defmodule NixTester.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      NixTesterWeb.Telemetry,
      NixTester.Repo,
      {DNSCluster, query: Application.get_env(:nix_tester, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: NixTester.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: NixTester.Finch},
      # Start a worker by calling: NixTester.Worker.start_link(arg)
      # {NixTester.Worker, arg},
      # Start to serve requests, typically the last entry
      NixTesterWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: NixTester.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    NixTesterWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
