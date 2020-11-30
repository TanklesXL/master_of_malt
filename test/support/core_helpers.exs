defmodule CoreHelpers do
  import ExUnit.Assertions, only: [assert: 1]

  def parse_and_build(html, module) do
    html
    |> Floki.parse_document!()
    |> module.new()
  end

  def assert_missing_key_errs(err, missing_keys, name) do
    for key <- missing_keys, do: assert(err =~ "key #{key} has no data")
    assert err =~ "error building #{name}: "
  end

  def assert_notes(actual, expected) do
    assert actual.nose == expected[:nose] |> String.trim()
    assert actual.palate == expected[:palate] |> String.trim()
    assert actual.finish == expected[:finish] |> String.trim()
    assert actual.overall == (expected[:overall] || "") |> String.trim()
  end

  def assert_card(actual, expected) do
    assert actual.name == expected[:name] |> String.trim()
    assert actual.img == ("https:" <> expected[:img]) |> String.trim()
    assert actual.desc == expected[:desc] |> String.trim()
    assert_notes(actual.notes, expected[:notes])
  end

  def notes_map do
    %{
      nose: nose(),
      palate: palate(),
      finish: finish(),
      overall: overall()
    }
  end

  def nose do
    "A ridge of vanilla leads to mountain of peat capped with citrus fruits and circled by clouds of sea spray."
  end

  def palate do
    "Sweet vanilla counterbalanced with lemon and lime followed by that surging Ardbeg smoke that we all know and love."
  end

  def finish do
    "Long and glorious; sea salted caramel and beach bonfire smoke."
  end

  def overall do
    "Precise balance, big smoke and non-chill filtered. This is why this is such a famous dram."
  end

  def name, do: "Ardbeg 10 Year Old"

  def desc do
    """
    A phenomenal whisky packing powerful peaty deliciousness, Ardbeg 10 Year Old is a favourite of many whisky lovers around the world.
    Produced on the Kildalton Coast of Islay, this single malt matures for a decade before being bottled without any chill-filtration.
    If you're after a whisky with full of coastal air, smoke and more, this is exactly what you want.
    """
  end

  def img do
    "//cdn2.masterofmalt.com/whiskies/p-2813/ardbeg/ardbeg-10-year-old-whisky.jpg?ss=2.0"
  end

  def notes_html(notes) do
    """
    <div>
     <p id="ContentPlaceHolder1_ctl00_ctl03_TastingNoteBox_ctl00_noseTastingNote" class="pageCopy">
       <b>Nose:</b>
       #{notes[:nose]}
     </p>
     <p id="ContentPlaceHolder1_ctl00_ctl03_TastingNoteBox_ctl00_palateTastingNote" class="pageCopy">
       <b>Palate:</b>
       #{notes[:palate]}
     </p>
     <p id="ContentPlaceHolder1_ctl00_ctl03_TastingNoteBox_ctl00_finishTastingNote" class="pageCopy">
       <b>Finish:</b>
       #{notes[:finish]}
     </p>
     <p id="ContentPlaceHolder1_ctl00_ctl03_TastingNoteBox_ctl00_overallTastingNote" class="pageCopy">
       <b>Overall:</b>
       #{notes[:overall]}
     </p>
    </div>
    """
  end

  def card_html(info) do
    """
    <div>
      <h2 id="ContentPlaceHolder1_pageH1">
        #{info[:name]}
      </h2>
      <img
        id="ContentPlaceHolder1_ctl00_ctl03_MobileProductImage_imgProductBig2"
        src="#{info[:img]}"
      />
      <div itemprop=description>
        <p>
          #{info[:desc]}
        </p>
      </div>
      #{notes_html(info[:notes])}
    </div>
    """
  end
end
