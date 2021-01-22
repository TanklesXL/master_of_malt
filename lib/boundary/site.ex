defmodule MasterOfMalt.Boundary.Site do
  use HTTPoison.Base
  @endpoint "https://www.masterofmalt.com"

  @impl true
  def process_url(url), do: @endpoint <> url

  @spec validate_url(url) :: :ok | {:error, String.t()}
  def validate_url(url) do
    cond do
      String.first(url) !== "/" ->
        {:error, "#{url} does not start with a forward slash"}

      String.last(url) !== "/" ->
        {:error, "#{url} does not end with a forward slash"}

      true ->
        :ok
    end
  end

  def endpoint do
    @endpoint
  end
end
