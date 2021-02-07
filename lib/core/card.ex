defmodule MasterOfMalt.Core.Card do
  alias MasterOfMalt.Core.Notes
  alias MasterOfMalt.Helpers.{HTML, Validation}

  @enforce_keys [:name, :img, :desc, :brand]
  defstruct [:name, :img, :desc, :notes, :brand]

  @type t :: %__MODULE__{
          name: String.t(),
          brand: String.t(),
          img: String.t(),
          desc: String.t(),
          notes: Notes.t()
        }

  @spec new(Floki.html_tree()) :: {:ok, t()} | {:error, String.t()}
  def new(html) do
    case Notes.new(html) do
      {:ok, notes} ->
        %__MODULE__{
          name: name(html),
          brand: brand(html),
          img: image_ref(html),
          desc: description(html),
          notes: notes
        }
        |> Validation.validate_string_keys(@enforce_keys, "card")

      err ->
        err
    end
  end

  defp name(html), do: HTML.attribute_from_meta(html, "og:title")

  defp brand(html), do: HTML.attribute_from_meta(html, "og:brand")

  defp image_ref(html), do: HTML.attribute_from_meta(html, "og:image")

  defp description(html), do: HTML.attribute_from_meta(html, "og:description")
end
