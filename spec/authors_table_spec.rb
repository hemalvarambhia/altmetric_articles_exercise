require 'ostruct'
require 'doi'

describe 'Authors table' do
  class AuthorsTable
    def initialize(authors = [])
      @authors = authors
    end

    def find(doi)
      author = @authors.select { |author| author.publications.include?(doi) }
      return [] if author.none?
      author.map { |author| author.name }
    end
  end
  
  describe '#find' do
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
            OpenStruct.new(name: 'No Match 1', publications: [a_doi]),
            OpenStruct.new(name: 'No Match 2', publications: [a_doi])
          ]
        )

        expect(authors_table.find(DOI.new('10.8899/altmetric02324'))).to eq []
      end
    end 

    context 'When the table contains the author of an article' do
      it 'returns the name of the author' do
        authors_table = AuthorsTable.new(
          [
            OpenStruct.new(name: 'Author', publications: [ DOI.new('10.1111/altmetric777') ]),
            OpenStruct.new(name: 'No Matching', publications: [a_doi])       
          ]
        )
        expect(authors_table.find(DOI.new('10.1111/altmetric777'))).to eq ['Author']
      end
    end

    context 'When the article is published by multiple authors' do
      it 'returns all the authors' do
        authors_table = AuthorsTable.new(
          [
            OpenStruct.new(name: 'Not Author', publications: [a_doi, a_doi]),
            OpenStruct.new(name: 'Main Author', publications: [ DOI.new('10.2954/altmetric9435') ]),
            OpenStruct.new(name: 'Co-Author 1', publications: [ DOI.new('10.2954/altmetric9435') ]),
            OpenStruct.new(name: 'Co-Author 2', publications: [ DOI.new('10.2954/altmetric9435') ])
          ]
        )

        expected = [ 'Main Author', 'Co-Author 1', 'Co-Author 2' ]
        expect(authors_table.find(DOI.new('10.2954/altmetric9435'))).to eq expected
      end
    end
  end

  def a_doi
    registrant = Array.new(4) { rand(0..9) }.join
    DOI.new("10.#{registrant}/altmetric#{rand(100000000)}")
  end
end