require 'issn'
describe 'Journals table' do
  class JournalsTable
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
  end
end