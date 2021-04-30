# IbmFunctionsBase

Base library to create Elixir IBM Functions

## Installation

The package can be installed by adding `ibm_function_base` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ibm_function_base, "~> 0.1.0"}
  ]
end
```

## Basic Usage

1. Create IBM Functions handler module. Implement handle(request, event, context) function.

```elixir
defmodule Upcase do
  use IbmFunctionsBase
  alias IbmFunctionsBase.Request
  alias IbmFunctionsBase.Response
  @impl IbmFunctionsBase
  def init(context) do
    {:ok, context}
  end
  @impl IbmFunctionsBase
  def handle(%Request{body: body} = request, event, context) do
    Logger.info(inspect(event))
    Logger.info(inspect(context))
    Logger.info(inspect(request))
    {:ok, Response.to_response(body |> Jason.encode! |> String.upcase, %{}, 200)}
    # {:ok, body |> Jason.encode! |> String.upcase}
  end
end
```

2. Create zip file for IBM Functions.

```
$ docker run -d -it --rm --name elx erintheblack/elixir-ibm-functions-builder:1.10.4
$ docker cp lib elx:/tmp
$ docker cp mix.exs elx:/tmp
$ docker exec elx /bin/bash -c "mix deps.get; MIX_ENV=prod mix ibm_functions.release ${ModuleName}"
$ docker cp elx:/tmp/${app_name}-${version}.zip .
$ docker stop elx
```

3. Publish.

```
$ ibmcloud fn action create ${app_name} ${app_name}-${version}.zip --native --web true --param ___LOG_LEVEL info
```

The docs can be found at [https://hexdocs.pm/azure_functions_base](https://hexdocs.pm/azure_functions_base).
