describe 'An article CSV doc' do
  ArticleCSVDoc = Class.new
  class ArticleCSVDoc
    def each
      row = {
        doi: '10.1234/altmetric1',
        title: 'About Physics',
        issn: '5463-4695'
      }
      yield row
    end
  end
  
  describe '#each' do
    it 'yields a row to the block' do
      article_csv_doc = ArticleCSVDoc.new
      expected_row = {
        doi: '10.1234/altmetric1', title: 'About Physics', issn: '5463-4695'
      }
      expect { |b| article_csv_doc.each(&b) }
        .to yield_successive_args expected_row
    end
  end
end
