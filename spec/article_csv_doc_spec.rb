require 'doi_helper'
require 'issn_helper'
describe 'An article CSV doc' do
  include CreateDOI, CreateISSN
  class ArticleCSVDoc
    def initialize rows = []
      @rows = rows.collect do |row|
        { doi: row[:doi], title: row[:title], issn: correct_issn(row[:issn]) }
      end
    end

    def read
      @rows
    end

    private

    def correct_issn(issn)
      dash_absent = issn.index('-').nil?
      corrected =  dash_absent ? issn.insert(4, '-') : issn

      corrected
    end
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

    describe 'when a row has an ISSN without the dash' do
      it 'adds the dash' do
        row_with_invalid_issn = a_row_with(issn: '12345678')
        article_csv_doc = ArticleCSVDoc.new [ row_with_invalid_issn ]

        content = article_csv_doc.read

        row = content.detect { |row| row[:doi] == row_with_invalid_issn[:doi] }
        expect(row[:issn]).to eq '1234-5678'
      end
    end
  end

  def a_row_with(params)
    a_row.merge params
  end

  def a_row
    { doi: generate_doi, title: 'Quantum Physics', issn: generate_issn }
  end
end
