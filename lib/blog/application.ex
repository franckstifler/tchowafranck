defmodule Blog.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children =
      [
        BlogWeb.Telemetry,
        Blog.Repo,
        {DNSCluster, query: Application.get_env(:blog, :dns_cluster_query) || :ignore},
        {Phoenix.PubSub, name: Blog.PubSub},
        Blog.Metrics,
        BlogWeb.Endpoint
      ] ++ post_parser_child()

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Blog.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp post_parser_child do
    if Application.get_env(:blog, :start_post_parser, true) do
      [Blog.PostParser]
    else
      []
    end
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BlogWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
