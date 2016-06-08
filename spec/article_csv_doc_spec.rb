require 'ostruct'
require 'support/create_doi'
require 'support/create_issn'
require 'article_csv_doc'
describe 'An article CSV doc' do
  include CreateDOI, CreateISSN

  it 'is empty by default' do
    article_csv_doc = ArticleCSVDoc.new

    expect(article_csv_doc).to be_empty
  end
  
  describe '#read' do
    it 'returns the content' do
      expected_row = [ a_row ]
      article_csv_doc = ArticleCSVDoc.new expected_row

      expect(article_csv_doc.read).to eq expected_row
    end

    it 'returns all of its rows' do
      expected_rows = Array.new(3) { a_row }
      article_csv_doc = ArticleCSVDoc.new(expected_rows)

      expect(article_csv_doc.read).to eq expected_rows
    end
  end

  def a_row
    OpenStruct.new(
      doi: generate_doi, title: 'Quantum Physics', issn: generate_issn
    )
  end
end
