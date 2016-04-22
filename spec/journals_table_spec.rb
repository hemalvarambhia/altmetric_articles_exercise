require 'issn'
describe 'Journals table' do
  class JournalsTable
    def initialize(rows = [])
      @journals = Hash[rows]
    end

    def find(issn)
      @journals.fetch(issn, '')
    end
  end

  describe '#find' do
    context 'When the table does not have a journal with the ISSN' do
      it 'returns no title' do
        journals_table = JournalsTable.new(
          [ 
            [ISSN.new('5155-3789'), 'Journal of Physics A'],
            [ISSN.new('8654-5652'), 'Journal of Physics B']
          ]
        )

        expect(journals_table.find(ISSN.new('8766-8334'))).to eq ''
      end
    end

    context 'When the table has a journal with the given ISSN' do
      it 'returns the title' do
        journals_table = JournalsTable.new(
          [
            [ISSN.new('2976-9674'), 'Chemical Physics Letters'],
            [ISSN.new('6195-6091'), 'Nature']
          ]
        )

        expect(journals_table.find(ISSN.new('2976-9674'))).to(
          eq 'Chemical Physics Letters'
        )
      end
    end
  end
end