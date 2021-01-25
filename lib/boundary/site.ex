defmodule MasterOfMalt.Boundary.Site do
  use HTTPoison.Base
  @endpoint "https://www.masterofmalt.com"

  @impl true
  def process_url(url), do: @endpoint <> url

  def endpoint, do: @endpoint
end
