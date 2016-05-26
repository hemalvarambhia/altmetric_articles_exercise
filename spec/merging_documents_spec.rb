describe 'merging documents and outputting the result to JSON' do
  it 'merges articles with authors and journals' do
    article_csv = double(:articles_csv)
    journals_csv = double(:journals_csv)
    authors_json = double(:authors_json)
    format = 'json'
    expect(article_csv).to(
        receive(:each).and_yield(
            { doi: '10.1234/altmetric0', title: 'About Physics', issn: '8456-2422' }
        ))
    expect(authors_json).to(
        receive(:find).with('10.1234/altmetric0').and_return [ 'Author' ])
    expect(journals_csv).to receive(:find).with('8456-2422').and_return 'Nature'

    merged_row = {}
    if format == 'json'
      article_csv.each do |article|
        merged_row[:doi] = article[:doi]
        merged_row[:title] = article[:title]
        merged_row[:author] = authors_json.find(article[:doi]).join
        merged_row[:journal] = journals_csv.find(article[:issn])
        merged_row[:issn] = article[:issn]
      end
    end

    expect(merged_row).to(
        eq(doi: '10.1234/altmetric0', title: 'About Physics', author: 'Author',
           journal: 'Nature', issn: '8456-2422')
    )
  end
end