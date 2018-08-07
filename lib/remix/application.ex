defmodule RemixedRemix.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(RemixedRemix.Worker, [])
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
