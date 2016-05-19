require 'journals_table'
require 'journal_helper'
require 'issn_helper'

describe 'Journals table' do
  include CreateISSN, CreateJournal
  
  describe '#find' do
    context 'when the table does not have a journal with the ISSN' do
      it 'returns no title' do
        required = an_issn
        journals_table = JournalsTable.new(
          [
            a_journal_with(issn: an_issn, title: 'Journal of Physics A'),
            a_journal_with(issn: an_issn, title: 'Journal of Physics B')
          ]
        )
        
        title = journals_table.find(required)

        non_such_title = nil
        expect(title).to eq non_such_title
      end
    end

    context 'when the table has a journal with the given ISSN' do
      it 'returns the title' do
        required = an_issn
        journals_table = JournalsTable.new(
          [
            a_journal_with(issn: required, title: 'Physical Review'),
            a_journal_with(issn: an_issn, title: 'Nature')
          ]
        )

        title = journals_table.find(required)
        
        expect(title).to(eq 'Physical Review')
      end
    end
  end
  
  describe '.from' do
    it 'loads the table from a file' do
      csv_rows = []
      doc = double(:journal_csv_doc)
      expect(doc).to receive(:read).and_return(csv_rows)

      JournalsTable.from doc
    end
  end

  describe 'duplicate journals' do
    it 'retains the first journal with the given ISSN' do
      issn = an_issn
      journals_table = JournalsTable.new(
        [
          a_journal_with(issn: issn, title: 'Journal of Physics A'),
          a_journal_with(issn: issn, title: 'Chemistry Journal'),
          a_journal_with(issn: issn, title: 'Journal of Nanotechnology')
        ]
      )

      title = journals_table.find(issn)
      
      expect(title).to eq 'Journal of Physics A'
    end
  end
end
