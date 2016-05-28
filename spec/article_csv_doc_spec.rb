describe 'An article CSV doc' do
  ArticleCSVDoc = Class.new
  class ArticleCSVDoc
    def initialize rows = {}
      @rows = rows ||
      {
        doi: '10.1234/altmetric1',
        title: 'About Physics',
        issn: '5463-4695'
      }
    end
    
    def each
      yield @rows
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
  end
end
