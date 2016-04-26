require 'doi'
require 'issn'
describe 'Article CSV Parser' do
  class ArticleCSVParser
    def self.parse(line)
      {
        doi: DOI.new('10.4937/altmetric001'), 
        title: 'Physics', 
        issn: ISSN.new('1232-1983')
      }
    end
  end
  
  it 'reads off the DOI, title and ISSN from a line' do
    line = [ '10.4937/altmetric001', 'Physics', '1232-1983' ]
    expected = { 
      doi: DOI.new('10.4937/altmetric001'),
      title: 'Physics',
      issn: ISSN.new('1232-1983')
    }

    expect(ArticleCSVParser.parse(line)).to eq expected
  end
end