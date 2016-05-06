require 'authors_table'
require 'article_author'
require 'doi_helper'

describe 'Authors table' do
  include CreateDOI

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
                ArticleAuthor.new(name: 'No Match 1', publications: [a_doi]),
                ArticleAuthor.new(name: 'No Match 2', publications: [a_doi])
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
            ArticleAuthor.new(name: 'Author', publications: [ required ]),
            ArticleAuthor.new(name: 'No Matching', publications: [a_doi])
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
            ArticleAuthor.new(name: 'Not Author', publications: [a_doi, a_doi]),
            ArticleAuthor.new(name: 'Main Author', publications: [ required ]),
            ArticleAuthor.new(name: 'Co-Author 1', publications: [ required ]),
            ArticleAuthor.new(name: 'Co-Author 2', publications: [ required, a_doi ])
          ]
        )

        expected = [ 'Main Author', 'Co-Author 1', 'Co-Author 2' ]
        expect(authors_table.find(required)).to eq expected
      end
    end
  end
end
