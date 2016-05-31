require 'doi_helper'
require 'issn_helper'
require 'issn'
require 'forwardable'
describe 'An article CSV doc' do
  include CreateDOI, CreateISSN
  class ArticleCSVDoc
    extend Forwardable
    include ISSN
    def_delegator :@rows, :empty?

    def initialize content = []
      @rows = content.collect do |row|
        { doi: row[:doi], title: row[:title], issn: correct_issn(row[:issn]) }
      end
    end

    def read
      @rows
    end
  end

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

  def a_row_with(params)
    a_row.merge params
  end

  def a_row
    { doi: generate_doi, title: 'Quantum Physics', issn: generate_issn }
  end
end
