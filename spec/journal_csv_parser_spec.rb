require 'issn'
require 'journal_csv_parser'
describe 'Parsing a line from the journal CSV file' do
  it 'reads off the ISSN and title from a line' do
    line = ['Journal of Mathematics', '1975-3545']

    expect(JournalCSVParser.parse(line)).to(
        eq({ISSN.new('1975-3545') => 'Journal of Mathematics'}))
  end

  it 'reads off the ISSN and title from any line' do
    line = ['Astrophysical Journal', '2016-1623']

    expect(JournalCSVParser.parse(line)).to(
      eq({ISSN.new('2016-1623') => 'Astrophysical Journal'})
    )
  end
end
