require 'doi'
describe 'Authors table' do
  class AuthorsTable
    def find(doi)
      []
    end
  end

  context 'When the table is empty' do
    it 'return no authors' do
      authors_table = AuthorsTable.new

      expect(authors_table.find(DOI.new('10.6453/altmetric490'))).to eq []
    end 
  end
end