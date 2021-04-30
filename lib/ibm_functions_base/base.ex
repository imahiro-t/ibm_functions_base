defmodule IbmFunctionsBase.Base do

  alias IbmFunctionsBase.Request
  alias IbmFunctionsBase.Response
  require Logger 

  def handle_event(event, context, module) do
    Logger.debug(inspect(event))
    Logger.debug(inspect(context))
    request = event |> Request.to_request
    module
    |> apply(:handle, [request, event, context])
    |> case do
      {:ok, %Response{} = result} ->
        Logger.debug(inspect(result))
        result
      {:ok, result} ->
        Logger.debug(result)
        result |> Response.to_response(%{}, 200)
      {:error, %Response{} = error} ->
        Logger.debug(inspect(error))
        error
      {:error, error} ->
        Logger.debug(error)
        error |> Response.to_response(%{}, 400)
    end
    |> response_message
    |> IO.puts
  end

  defp response_message(%Response{body: body, headers: headers, status_code: status_code}) do
    %{
      headers: headers,
      body: body,
      statusCode: status_code
    } |> Jason.encode!
  end

end