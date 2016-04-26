require 'issn'
describe 'Parsing a line from the journal CSV file' do
  class JournalCSVParser
    def self.parse line
      [ISSN.new(line.first), line.last]
    end
  end

  it 'reads off the ISSN and title' do
    line = ['1975-3545', 'Journal of Mathematics']

    expect(JournalCSVParser.parse(line)).to(
        eq([ISSN.new('1975-3545'), 'Journal of Mathematics']))
  end

  it 'reads off any ISSN and title' do
    line = ['2016-1623','Astrophysical Journal']

    expect(JournalCSVParser.parse(line)).to(
      eq([ISSN.new('2016-1623'), 'Astrophysical Journal'])
    )
  end
end