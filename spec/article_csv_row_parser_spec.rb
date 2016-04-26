require 'doi'
require 'issn'
describe 'Article CSV Parser' do
  class ArticleCSVParser
    def self.parse(line)
      {
        doi: DOI.new(line.first), 
        title: line[1], 
        issn: ISSN.new(line.last)
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

  it 'reads off the DOI, title and ISSN from any line' do
    line = [ '10.7503/altmetric123', 'Astrophysics', '1912-2223' ]
    expected = {
      doi: DOI.new('10.7503/altmetric123'),
      title: 'Astrophysics',
      issn: ISSN.new('1912-2223')
    }

    expect(ArticleCSVParser.parse(line)).to eq expected
  end
end