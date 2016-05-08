require 'journals_table'
require 'issn'
describe 'Journals table' do
  describe '.from' do
    it 'loads the table from a file' do
      csv_rows = [nil]
      doc = double(:journal_csv_doc)
      expect(doc).to receive(:read).and_return(csv_rows)

      JournalsTable.from doc
    end
  end

  describe '#find' do
    context 'when the table does not have a journal with the ISSN' do
      it 'returns no title' do
        journals_table = JournalsTable.new(
            [ ISSN.new('5155-3789'), 'Journal of Physics A' ],
            [ ISSN.new('8654-5652'), 'Journal of Physics B' ]
        )

        expect(journals_table.find(ISSN.new('8766-8334'))).to be_nil
      end
    end

    context 'when the table has a journal with the given ISSN' do
      it 'returns the title' do
        journals_table = JournalsTable.new(
            [ ISSN.new('2976-9674'), 'Chemical Physics Letters' ],
            [ ISSN.new('6195-6091'), 'Nature' ]
        )

        expect(journals_table.find(ISSN.new('2976-9674'))).to(
          eq 'Chemical Physics Letters'
        )
      end
    end
  end
end
