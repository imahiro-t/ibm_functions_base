defmodule IbmFunctionsBase do
  @moduledoc """
  This is IBM functions base.
  Use IbmFunctionsBase and implement `handle(event, context)` function
  """

  alias IbmFunctionsBase.Request
  alias IbmFunctionsBase.Response

  @doc """
  IBM runtime call init function.
  """
  @callback init(context :: map()) :: {:ok, map()}

  @doc """
  IBM runtime call handle function.
  """
  @callback handle(request :: Request.t, event :: map(), context :: map()) :: {:ok, Response.t} | {:ok, String.t} | {:error, Response.t} | {:error, String.t}

  defmacro __using__(_opts) do
    quote do
      require Logger
      @behaviour IbmFunctionsBase
      def start() do
        context = System.get_env
        event = context |> Map.get("___EVENT", "{}") |> Jason.decode!
        log_level = event |> Map.get("___LOG_LEVEL", "INFO") |> String.downcase |> String.to_atom
        Logger.configure(level: log_level)
        event = event |> Map.delete("___LOG_LEVEL")
        {:ok, context} = __MODULE__.init(context)
        IbmFunctionsBase.Base.handle_event(event, context, __MODULE__)
      end
    end
  end

end
