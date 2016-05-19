require 'issn'
require 'journal_csv_parser'
describe 'Parsing a line from the journal CSV file' do
  it 'reads off the ISSN and title from a line' do
    line = ['Journal of Mathematics', '1975-3545']

    parsed_row = JournalCSVParser.parse(line)
    
    expect(parsed_row).to(
      eq(a_journal_with(
           issn: ISSN.new('1975-3545'), title: 'Journal of Mathematics')
        )
    )
  end

  it 'reads off the ISSN and title from any line' do
    line = ['Astrophysical Journal', '2016-1623']

    expect(JournalCSVParser.parse(line)).to(
      eq(a_journal_with(
           issn: ISSN.new('2016-1623'), title: 'Astrophysical Journal')
        )
    )
  end

  def a_journal_with(args)
    [ args[:issn], args[:title] ]
  end
end
