require 'article_csv_parser'
describe 'Article CSV Parser' do
  describe 'when the ISSN is missing a dash' do
    it 'adds it in' do
      row = { doi: nil, title: nil, issn: '12345678' }
      
      expected_row = { doi: nil, title: nil, issn: '1234-5678' }
      expect(ArticleCSVParser.parse row).to eq expected_row 
    end
  end
end
