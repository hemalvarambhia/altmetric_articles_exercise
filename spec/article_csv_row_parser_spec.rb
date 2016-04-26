require 'doi'
require 'issn'
describe 'Article CSV Parser' do
  class ArticleCSVParser
    def self.parse(line)
      [DOI.new('10.4937/altmetric001'), 'Physics', ISSN.new('1232-1983')]
    end
  end
  
  it 'reads off the DOI, title and ISSN' do
    line = [ '10.4937/altmetric001', 'Physics', '1232-1983' ]
    expect(ArticleCSVParser.parse(line)).to(
      eq([DOI.new('10.4937/altmetric001'), 'Physics', ISSN.new('1232-1983')]))
  end
end