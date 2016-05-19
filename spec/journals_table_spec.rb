require 'journals_table'
require 'issn_helper'
require 'issn'
describe 'Journals table' do
  include CreateISSN
  describe '#find' do
    context 'when the table does not have a journal with the ISSN' do
      it 'returns no title' do
        required_issn = an_issn
        journals_table = JournalsTable.new(
          [
            [ an_issn, 'Journal of Physics A' ],
            [ an_issn, 'Journal of Physics B' ]
          ]
        )
        
        title = journals_table.find(required_issn)

        non_existent_title = nil
        expect(title).to eq non_existent_title
      end
    end

    context 'when the table has a journal with the given ISSN' do
      it 'returns the title' do
        required_issn = an_issn
        journals_table = JournalsTable.new(
          [
            [ required_issn, 'Chemical Physics Letters' ],
            [ an_issn, 'Nature' ]
          ]
        )

        title = journals_table.find(required_issn)
        
        expect(title).to(eq 'Chemical Physics Letters')
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
          [ issn, 'Journal of Physics A' ],
          [ issn, 'Chemistry Journal' ],
          [ issn, 'Journal of Nanotechnology' ]
        ]
      )

      title = journals_table.find(issn)
      
      expect(title).to eq 'Journal of Physics A'
    end
  end
end
