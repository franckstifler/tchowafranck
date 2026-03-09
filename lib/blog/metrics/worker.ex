defmodule Blog.Metrics.Worker do
  use GenServer, restart: :temporary

  @registry Blog.Metrics.Registry
  @repo Blog.Repo

  def start_link(path) do
    GenServer.start_link(__MODULE__, path, name: {:via, Registry, {@registry, path}})
  end

  @impl true
  def init(path) do
    Process.flag(:trap_exit, true)
    {:ok, {path, _counter = 0}}
  end

  @impl true
  def handle_info(:bump, {path, 0}) do
    schedule_upsert()
    {:noreply, {path, 1}}
  end

  @impl true
  def handle_info(:bump, {path, counter}) do
    {:noreply, {path, counter + 1}}
  end

  @impl true
  def handle_info(:upsert, {path, counter}) do
    upsert!(path, counter)
    {:noreply, {path, 0}}
  end

  defp schedule_upsert() do
    Process.send_after(self(), :upsert, Enum.random(10..20) * 1_000)
  end

  defp upsert!(path, counter) do
    import Ecto.Query

    date = Date.utc_today()

    query = from(m in Blog.Metrics.Metric, update: [inc: [counter: ^counter]])

    @repo.insert!(
      %Blog.Metrics.Metric{date: date, path: path, counter: counter},
      on_conflict: query,
      conflict_target: [:date, :path]
    )
  end

  @impl true
  def terminate(_, {_path, 0}), do: :ok
  def terminate(_, {path, counter}), do: upsert!(path, counter)
end
