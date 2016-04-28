require 'ostruct'
require 'doi'

describe 'Authors table' do
  class AuthorsTable
    def self.from document
      new document.read
    end

    def initialize(authors = [])
      @authors = authors
    end

    def find(doi)
      author = @authors.select { |author| author.publications.include?(doi) }
      author.map { |author| author.name }
    end
  end

  describe '.from' do
    it 'loads the table from a file' do
      doc = double(:author_json_doc)
      expect(doc).to receive(:read)

      AuthorsTable.from doc
    end
  end
  
  describe '#find' do
    context 'when there are no authors of an article' do
      it 'returns no authors' do
        required = DOI.new('10.8899/altmetric02324')
        authors_table = AuthorsTable.new(
            [
                OpenStruct.new(name: 'No Match 1', publications: [a_doi]),
                OpenStruct.new(name: 'No Match 2', publications: [a_doi])
            ]
        )

        expect(authors_table.find(required)).to eq []
      end
    end 

    context 'when the table contains the author of an article' do
      it 'returns the name of the author' do
        required = DOI.new('10.1111/altmetric777')
        authors_table = AuthorsTable.new(
          [
            OpenStruct.new(name: 'Author', publications: [ required ]),
            OpenStruct.new(name: 'No Matching', publications: [a_doi])       
          ]
        )
        expect(authors_table.find(required)).to eq ['Author']
      end
    end

    context 'when the article is published by multiple authors' do
      it "returns all the authors' names" do
        required = DOI.new('10.2954/altmetric9435')
        authors_table = AuthorsTable.new(
          [
            OpenStruct.new(name: 'Not Author', publications: [a_doi, a_doi]),
            OpenStruct.new(name: 'Main Author', publications: [ required ]),
            OpenStruct.new(name: 'Co-Author 1', publications: [ required ]),
            OpenStruct.new(name: 'Co-Author 2', publications: [ required, a_doi ])
          ]
        )

        expected = [ 'Main Author', 'Co-Author 1', 'Co-Author 2' ]
        expect(authors_table.find(required)).to eq expected
      end
    end
  end

  def a_doi
    registrant = Array.new(4) { rand(0..9) }.join
    DOI.new("10.#{registrant}/altmetric#{rand(100000000)}")
  end
end