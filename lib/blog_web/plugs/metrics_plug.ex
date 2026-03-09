defmodule BlogWeb.Plugs.MetricsPlug do
  @moduledoc """
  Plug to track page views for analytics.
  Only tracks successful (200) HTML responses.
  """

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    register_before_send(conn, fn conn ->
      if conn.status == 200 && html_request?(conn) do
        path = "/" <> Enum.join(conn.path_info, "/")
        Blog.Metrics.bump(path)
      end

      conn
    end)
  end

  defp html_request?(conn) do
    case get_req_header(conn, "accept") do
      ["*/*" | _] -> true
      [header | _] -> String.contains?(header, "text/html")
      [] -> true
    end
  end
end
