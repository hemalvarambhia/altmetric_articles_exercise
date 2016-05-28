require 'forwardable'
describe 'An article CSV doc' do
  class ArticleCSVParser
    def self.parse row
      issn = row[:issn]
      corrected_issn = has_dash?(issn) ? issn : issn.insert(4, '-')
      { doi: row[:doi], title: row[:title], issn: corrected_issn }
    end

    def self.has_dash?(issn)
      issn.index('-')
    end
  end
  
  class ArticleCSVDoc
    def initialize row = {}
      @row = row
    end

    def each
      yield ArticleCSVParser.parse(@row)
    end
  end
  
  describe '#each' do
    it 'yields a row to the block' do
      expected_row = {
        doi: '10.1234/altmetric1', title: 'About Physics', issn: '5463-4695'
      }
      article_csv_doc = ArticleCSVDoc.new expected_row

      expect { |b| article_csv_doc.each(&b) }
        .to yield_successive_args expected_row
    end

    it 'yields any row to the block' do
      expected_row = {
        doi: '10.1234/altmetric2', title: 'About Chemistry', issn: '1234-5678'
      }
      article_csv_doc = ArticleCSVDoc.new expected_row
      
      expect { |b| article_csv_doc.each(&b) }
        .to yield_successive_args expected_row
    end

    context 'when the ISSN is missing a dash' do
      it 'adds it in' do
        row = { doi: nil, title: nil, issn: '12345678' }
        article_csv_doc = ArticleCSVDoc.new row
        
        expected_row = { doi: nil, title: nil, issn: '1234-5678' }
        expect { |b| article_csv_doc.each(&b) }
          .to yield_successive_args expected_row 
      end
    end
  end
end
