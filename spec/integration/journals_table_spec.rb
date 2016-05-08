require 'csv'
require 'altmetric_file'
require 'journal_csv_parser'
require 'journals_table'
describe JournalsTable do
  it 'searches for journals by ISSN' do
    path_to_journal_csv = File.join(
      File.dirname(__FILE__), 'sample_docs', 'one_journal.csv'
    )
    journals_csv_doc = AltmetricFile.new(
      CSV.new(File.open(path_to_journal_csv), {headers: true}),
      JournalCSVParser
    )
    journals_table = JournalsTable.from(journals_csv_doc)
  
    issn = ISSN.new('1337-8688')
    expect(journals_table.find(issn)).to eq 'Bartell-Collins'
  end
end
