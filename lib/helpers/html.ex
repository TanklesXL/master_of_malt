defmodule MasterOfMalt.Helpers.HTML do
  @spec find_text(binary() | Floki.html_tree(), binary()) :: String.t()
  def find_text(html, selector) do
    html
    |> Floki.find(selector)
    |> Floki.text(deep: false)
    |> String.trim()
  end
end
