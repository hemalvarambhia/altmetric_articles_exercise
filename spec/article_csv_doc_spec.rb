require 'article_csv_parser'
describe 'An article CSV doc' do
  class ArticleCSVDoc
    def initialize rows = {}
      @rows = rows
    end

    def each
      @rows.each { |row| yield ArticleCSVParser.parse(row) }
    end
  end
  
  describe '#each' do
    it 'yields a row to the block' do
      expected_row = {
        doi: '10.1234/altmetric1', title: 'About Physics', issn: '5463-4695'
      }
      article_csv_doc = ArticleCSVDoc.new [ expected_row ]

      expect { |b| article_csv_doc.each(&b) }
        .to yield_successive_args expected_row
    end

    it 'yields any row to the block' do
      expected_row = {
        doi: '10.1234/altmetric2', title: 'About Chemistry', issn: '1234-5678'
      }
      article_csv_doc = ArticleCSVDoc.new [ expected_row ]
      
      expect { |b| article_csv_doc.each(&b) }
        .to yield_successive_args expected_row
    end

    it 'yields all rows to the block' do
      expected_rows = [
        { doi: '10.1234/altmetric0', title: 'Maths', issn: '8765-4321' },
        { doi: '10.1234/altmetric1', title: 'Physics', issn: '5764-3242' },
        { doi: '10.1432/altmetric2', title: 'Chemistry', issn: '5893-1355' }
      ]
      article_csv_doc = ArticleCSVDoc.new(expected_rows)
      expect { |b| article_csv_doc.each(&b) }
        .to yield_successive_args *expected_rows
    end
  end
end
