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
end
