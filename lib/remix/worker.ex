defmodule RemixedRemix.Worker do
  require Logger
  use GenServer

  @name __MODULE__

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: @name)
  end

  def init(state) do
    Process.send_after(@name, :poll_and_reload, 10000)
    {:ok, state}
  end

  def handle_info(:poll_and_reload, state) do
    new_state =
      Map.new(paths(), fn path ->
        current_mtime = get_current_mtime(path)

        last_mtime =
          case Map.fetch(state, path) do
            {:ok, val} -> val
            :error -> nil
          end

        handle_path(path, current_mtime, last_mtime)
      end)

    Process.send_after(@name, :poll_and_reload, 1000)
    {:noreply, new_state}
  end

  def handle_path(path, current_mtime, current_mtime), do: {path, current_mtime}

  def handle_path(path, current_mtime, _) do
    comp_elixir =
      if Mix.Project.umbrella?() do
        fn -> Mix.ProjectStack.recur(fn -> recursive_compile() end) end
      else
        fn -> Mix.Tasks.Compile.Elixir.run(["--ignore-module-conflict"]) end
      end

    comp_escript = fn -> Mix.Tasks.Escript.Build.run([]) end

    case Application.get_all_env(:remixed_remix)[:silent] do
      true ->
        ExUnit.CaptureIO.capture_io(comp_elixir)

        if Application.get_all_env(:remixed_remix)[:escript] == true do
          ExUnit.CaptureIO.capture_io(comp_escript)
        end

      _ ->
        comp_elixir.()

        if Application.get_all_env(:remixed_remix)[:escript] == true do
          comp_escript.()
        end
    end

    {path, current_mtime}
  end

  def get_current_mtime(dir) do
    case File.ls(dir) do
      {:ok, files} -> get_current_mtime(files, [], dir)
      _ -> nil
    end
  end

  def get_current_mtime([], mtimes, _cwd) do
    mtimes
    |> Enum.sort()
    |> Enum.reverse()
    |> List.first()
  end

  def get_current_mtime([head | tail], mtimes, cwd) do
    mtime =
      case File.dir?("#{cwd}/#{head}") do
        true -> get_current_mtime("#{cwd}/#{head}")
        false -> File.stat!("#{cwd}/#{head}").mtime
      end

    get_current_mtime(tail, [mtime | mtimes], cwd)
  end

  defp paths, do: Application.get_env(:remixed_remix, :paths, default_paths())

  defp default_paths do
    if Mix.Project.umbrella?() do
      {:ok, apps} = File.ls("apps/")
      Enum.map(apps, fn x -> "apps/#{x}/lib" end)
    else
      ["lib"]
    end
  end

  defp recursive_compile do
    # Borrowed from Mix.Task with modification
    config = Mix.Project.deps_config() |> Keyword.delete(:deps_path)

    for %Mix.Dep{app: app, opts: opts} <- Mix.Dep.Umbrella.cached() do
      Mix.Project.in_project(app, opts[:path], config, fn _ ->
        Mix.Tasks.Compile.Elixir.run(["--ignore-module-conflict"])
      end)
    end
  end
end
