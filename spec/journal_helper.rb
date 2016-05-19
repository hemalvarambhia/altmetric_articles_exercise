module CreateJournal
  def a_journal_with(args)
    [ args[:issn], args[:title] ]
  end
end
