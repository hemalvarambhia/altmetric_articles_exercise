require 'issn'
describe 'Journals table' do
  class JournalsTable
    def initialize(rows = [])

    end

    def find(issn)
      ''
    end
  end

  describe '#find' do
    context 'When the table is empty' do
      it 'returns no title' do
        journals_table = JournalsTable.new
        
        expect(journals_table.find(ISSN.new('1234-4384'))).to eq ''
      end
    end

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
  end
end