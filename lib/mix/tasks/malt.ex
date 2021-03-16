defmodule Mix.Tasks.Malt do
  use Mix.Task

  @flags strict: [async: :boolean]

  def run(args) do
    {:ok, _started} = Application.ensure_all_started(:httpoison)
    {opts, urls, _errs} = OptionParser.parse(args, @flags)

    urls
    |> MasterOfMalt.scrape_many(Keyword.get(opts, :async, false))
    |> Stream.map(fn res ->
      case res do
        {:ok, card} -> "\nSUCCESS:\n#{card}"
        {:error, reason} -> "\nFAILURE: #{reason}"
      end
    end)
    |> Enum.each(&IO.puts/1)
  end

  defimpl String.Chars, for: MasterOfMalt.Core.Notes do
    def to_string(notes) do
      base = "Nose:\t#{notes.nose}\nPalate:\t#{notes.palate}\nFinish:\t#{notes.finish}"

      if notes.overall !== "", do: base <> "\nOverall:\t#{notes.overall}\n", else: base
    end
  end

  defimpl String.Chars, for: MasterOfMalt.Core.Card do
    def to_string(card) do
      "#{card.name}:\nBrand: #{card.brand}\n\t#{card.desc}\n\nImage:\t#{card.img}\n#{card.notes}"
    end
  end
end
