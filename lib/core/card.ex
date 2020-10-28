defmodule MasterOfMalt.Core.Card do
  alias MasterOfMalt.Core.Notes
  alias MasterOfMalt.Helpers.{HTML, Validation}

  @enforce_keys [:name, :img, :desc]
  defstruct [:name, :img, :desc, :notes]

  @type t :: %__MODULE__{
          name: String.t(),
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
          img: image_ref(html),
          desc: description(html),
          notes: notes
        }
        |> Validation.validate_string_keys(@enforce_keys, "card")

      err ->
        err
    end
  end

  defp name(html), do: HTML.find_text(html, "#ContentPlaceHolder1_pageH1")

  defp image_ref(html) do
    src =
      html
      |> Floki.find("#ContentPlaceHolder1_ctl00_ctl02_MobileProductImage_imgProductBig2")
      |> Floki.attribute("src")
      |> List.first()

    case src do
      "" -> ""
      src -> "https:#{src}"
    end
  end

  defp description(html), do: HTML.find_text(html, "[itemprop=description] p")

  defimpl String.Chars do
    def to_string(card) do
      """
      #{card.name}
        Description:
          #{card.desc}
        Image:
          #{card.img}
        Notes:
          #{Kernel.to_string(card.notes)}
      """
    end
  end
end
