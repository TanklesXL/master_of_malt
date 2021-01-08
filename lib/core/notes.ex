defmodule MasterOfMalt.Core.Notes do
  alias MasterOfMalt.Helpers.{HTML, Validation}

  @enforce_keys [:nose, :palate, :finish]
  defstruct [:nose, :palate, :finish, :overall]

  @type t :: %__MODULE__{
          nose: String.t(),
          palate: String.t(),
          finish: String.t(),
          overall: String.t()
        }

  @spec new(Floki.html_tree()) :: {:ok, t()} | {:error, String.t()}
  def new(html) do
    data =
      [
        nose: "#ContentPlaceHolder1_ctl00_ctl02_TastingNoteBox_ctl00_noseTastingNote",
        palate: "#ContentPlaceHolder1_ctl00_ctl02_TastingNoteBox_ctl00_palateTastingNote",
        finish: "#ContentPlaceHolder1_ctl00_ctl02_TastingNoteBox_ctl00_finishTastingNote",
        overall: "#ContentPlaceHolder1_ctl00_ctl02_TastingNoteBox_ctl00_overallTastingNote"
      ]
      |> Enum.map(fn {k, v} -> {k, HTML.find_text(html, v)} end)

    __MODULE__
    |> struct(data)
    |> Validation.validate_string_keys(@enforce_keys, "notes")
  end
end
