require 'ostruct'
require 'doi'

describe 'Authors table' do
  class AuthorsTable
    def initialize(authors = [])

    end

    def find(doi)
      []
    end
  end

  context 'When the table is empty' do
    it 'returns no authors' do
      authors_table = AuthorsTable.new

      expect(authors_table.find(DOI.new('10.6453/altmetric490'))).to eq []
    end 
  end

  context 'When there are no authors of an article' do
    it 'returns no authors' do
      authors_table = AuthorsTable.new(
        [
          OpenStruct.new(name: 'Author 1', publications: [DOI.new('10.3454/altmetric001')]),
          OpenStruct.new(name: 'Author 1', publications: [DOI.new('10.4854/altmetric021')])
        ]
      )

      expect(authors_table.find(DOI.new('10.8899/altmetric02324'))).to eq []
    end
  end 
end