describe 'merging documents and outputting the result to JSON' do
  def merge(article_csv_doc, author_json_doc, journal_csv_doc, format)
    merged_row = {}
    if format == 'json'
      article_csv_doc.each do |article|
        merged_row[:doi] = article[:doi]
        merged_row[:title] = article[:title]
        merged_row[:author] = author_json_doc.find(article[:doi]).join
        merged_row[:journal] = journal_csv_doc.find(article[:issn])
        merged_row[:issn] = article[:issn]
      end
    end

    merged_row
  end

  it 'merges articles with authors and journals' do
    article_csv_doc = double(:articles_csv)
    journal_csv_doc = double(:journals_csv)
    author_json_doc = double(:authors_json)
    format = 'json'
    expect(article_csv_doc).to(
        receive(:each).and_yield(
            { doi: '10.1234/altmetric0', title: 'About Physics', issn: '8456-2422' }
        ))
    expect(author_json_doc).to(
        receive(:find).with('10.1234/altmetric0').and_return [ 'Author' ])
    expect(journal_csv_doc).to receive(:find).with('8456-2422').and_return 'Nature'

    merged_row = merge(article_csv_doc, author_json_doc, journal_csv_doc, format)

    expect(merged_row).to(
        eq(doi: '10.1234/altmetric0', title: 'About Physics', author: 'Author',
           journal: 'Nature', issn: '8456-2422')
    )
  end
end