defmodule MasterOfMalt do
  alias HTTPoison.{Error, Response}
  alias MasterOfMalt.Boundary.Site
  alias MasterOfMalt.Core.Card

  @type card_result :: {:error, String.t()} | {:ok, Card.t()}

  @spec scrape_many(list(binary), boolean()) :: list(card_result())
  def scrape_many(urls, _async \\ false)
  def scrape_many(urls, false), do: Enum.map(urls, &scrape_single/1)

  def scrape_many(urls, true) do
    urls
    |> Task.async_stream(&scrape_single/1)
    |> Enum.map(fn {:ok, res} -> res end)
  end

  @spec scrape_single(binary) :: card_result()
  def scrape_single(url) do
    with {:ok, %Response{status_code: 200, body: body}} <- Site.get(url),
         {:ok, html} <- Floki.parse_document(body),
         {:ok, _card} = res <- Card.new(html) do
      res
    else
      {:ok, %Response{status_code: code}} ->
        {:error, error_message(url, "unexpected status: HTTP #{code}")}

      {:error, %Error{reason: reason}} ->
        {:error, error_message(url, reason)}

      {:error, reason} ->
        {:error, error_message(url, reason)}
    end
  end

  defp error_message(url, reason), do: "failed on #{url}: #{reason}"
end
