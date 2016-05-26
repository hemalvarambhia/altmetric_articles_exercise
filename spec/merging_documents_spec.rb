def some_authors
  ['Biologist', 'Chemist', 'Physicist', 'Engineer']
end

def some_journals
  ['J. Chem. Phys.', 'J. Bio.', 'J. Phys. B']
end

describe 'merging documents and outputting the result to JSON' do
  def merge(article_csv_doc, author_json_doc, journal_csv_doc, format)
    rows = []
    if format == 'json'
      article_csv_doc.each do |article|
        rows <<
            {
                doi: article[:doi],
                title: article[:title],
                author: author_json_doc.find(article[:doi]).join,
                journal: journal_csv_doc.find(article[:issn]),
                issn: article[:issn]
            }
      end
    end

    rows
  end

  before :each do
    @article_csv_doc = double(:articles_csv)
    @journal_csv_doc = double(:journals_csv)
    @author_json_doc = double(:authors_json)
    @format = 'json'
  end

  it 'merges an article with its authors and the journal it was published in' do
    allow(@article_csv_doc).to(
        receive(:each).and_yield(
            { doi: '10.1234/altmetric0', title: 'About Physics', issn: '8456-2422' }
        ))
    allow(@author_json_doc).to(
        receive(:find).with('10.1234/altmetric0').and_return [ 'Author' ])
    allow(@journal_csv_doc).to receive(:find).with('8456-2422').and_return 'Nature'

    merged_row = merge(@article_csv_doc, @author_json_doc, @journal_csv_doc, @format)

    expected = {
        doi: '10.1234/altmetric0', title: 'About Physics', author: 'Author',
        journal: 'Nature', issn: '8456-2422'
    }
    expect(merged_row).to(include(expected))
  end

  it 'merges all articles with their authors and the journal it was published in' do
    rows = [
        {doi: '10.1234/altmetric1', title: 'About Chemistry', issn: '6844-2395'},
        {doi: '10.1234/altmetric2', title: 'About Biology', issn: '5679-2344'}
    ]
    allow(@article_csv_doc).to(
        receive(:each).and_yield(rows.first).and_yield(rows.last))
    authors = some_authors
    allow(@author_json_doc).to(
        receive(:find).with(any_args).and_return authors.sample(1))
    journals = some_journals
    allow(@journal_csv_doc).to receive(:find).with(any_args).and_return journals.sample

    merged_rows = merge(@article_csv_doc, @author_json_doc, @journal_csv_doc, @format)

    expect(merged_rows.size).to eq rows.size
  end
end