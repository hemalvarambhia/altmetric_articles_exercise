describe 'merging documents and outputting the result to JSON' do
  def merge(article_csv_doc, author_json_doc, journal_csv_doc, format)
    rows = []
    if format == 'json'
      article_csv_doc.each do |article|
        rows = [
            {
                doi: article[:doi],
                title: article[:title],
                author: author_json_doc.find(article[:doi]).join,
                journal: journal_csv_doc.find(article[:issn]),
                issn: article[:issn]

            }
        ]
      end
    end

    rows
  end

  it 'merges an article with its authors and the journal it was published in' do
    article_csv_doc = double(:articles_csv)
    journal_csv_doc = double(:journals_csv)
    author_json_doc = double(:authors_json)
    format = 'json'
    allow(article_csv_doc).to(
        receive(:each).and_yield(
            { doi: '10.1234/altmetric0', title: 'About Physics', issn: '8456-2422' }
        ))
    allow(author_json_doc).to(
        receive(:find).with('10.1234/altmetric0').and_return [ 'Author' ])
    allow(journal_csv_doc).to receive(:find).with('8456-2422').and_return 'Nature'

    merged_row = merge(article_csv_doc, author_json_doc, journal_csv_doc, format)

    expected = {
        doi: '10.1234/altmetric0', title: 'About Physics', author: 'Author',
        journal: 'Nature', issn: '8456-2422'
    }
    expect(merged_row).to(include(expected))
  end
end