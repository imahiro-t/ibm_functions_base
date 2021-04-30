defmodule Mix.Tasks.IbmFunctions.Release do
  @moduledoc """
  Create zip file for IBM Functions with custom runtime.

  Run this task inside Docker image `elixir:1.10.4-slim`.

  ## How to build

  ```
  $ docker run -d -it --rm --name elx erintheblack/elixir-ibm-functions-builder:1.10.4
  $ docker cp mix.exs elx:/tmp
  $ docker cp lib elx:/tmp
  $ docker exec elx /bin/bash -c "mix deps.get; MIX_ENV=prod mix ibm_functions.release"
  $ docker cp elx:/tmp/${app_name}-${version}.zip .
  $ docker stop elx
  ```
  """

  use Mix.Task

  @doc """
  Create zip file for IBM functions with custom runtime.
  """
  @impl Mix.Task
  def run([handler_module]) do
    app_name = app_name()
    version = version()
    bootstrap = bootstrap(app_name, handler_module)
    env = Mix.env
    Mix.Shell.cmd("rm -f -R ./_build/#{env}/*", &IO.puts/1)
    Mix.Shell.cmd("MIX_ENV=#{env} mix release --quiet", &IO.puts/1)
    File.write("./_build/#{env}/rel/#{app_name}/exec", bootstrap)
    Mix.Shell.cmd("chmod +x ./_build/#{env}/rel/#{app_name}/exec", &IO.puts/1)
    Mix.Shell.cmd("cd ./_build/#{env}/rel/#{app_name}; zip #{app_name}-#{version}.zip -r -q *", &IO.puts/1)
    Mix.Shell.cmd("mv -f ./_build/#{env}/rel/#{app_name}/#{app_name}-#{version}.zip ./", &IO.puts/1)
  end

  defp app_name do
    Mix.Project.config |> Keyword.get(:app) |> to_string
  end

  defp version do
    Mix.Project.config |> Keyword.get(:version)
  end

  defp bootstrap(app_name, handler_module) do
"""
#!/bin/sh
set -e
export ___EVENT=$1
chmod 755 bin/#{app_name}
chmod 755 releases/*/elixir
chmod 755 erts-*/bin/*
exec "bin/#{app_name}" "eval" "#{handler_module}.start"
"""
  end
end
