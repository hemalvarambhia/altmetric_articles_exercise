#Title,ISSN
#Bartell-Collins,1167-8230
require 'issn'
require 'journal_csv_doc'
require 'altmetric_file'
require 'journal_csv_parser'
describe 'Parsing Journal CSV Docs' do
  it 'reads of the title and ISSN' do
    expected = [ ISSN.new('1167-8230'), 'Bartell-Collins' ]
    path_to_journal_csv = File.join(
      File.dirname(__FILE__), 'sample_docs', 'one_journal.csv'
    )
    journal_csv = JournalCSVDoc.new(File.open(path_to_journal_csv))
    altmetric_file = AltmetricFile.new(journal_csv, JournalCSVParser)
    
    expect(altmetric_file.read).to eq (expected)
  end
end
