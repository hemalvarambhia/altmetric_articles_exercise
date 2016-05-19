require 'authors_table'
require 'article_author'
require 'doi_helper'

describe 'Authors table' do
  include CreateDOI

  describe '.from' do
    it 'loads the table from a file' do
      authors_json = []
      doc = double(:author_json_doc)
      expect(doc).to receive(:read).and_return authors_json

      AuthorsTable.from doc
    end
  end
  
  describe '#find' do
    context 'when there are no authors of an article' do
      it 'returns no authors' do
        required = a_doi
        authors_table = AuthorsTable.new(
          [
            ArticleAuthor.new(name: 'No Match 1', publications: [a_doi]),
            ArticleAuthor.new(name: 'No Match 2', publications: [a_doi])
          ]
        )

        author_of_article = authors_table.find(required)

        no_authors = []
        expect(author_of_article).to eq no_authors
      end
    end 

    context 'when the table contains the author of an article' do
      it 'returns the name of the author' do
        required = a_doi
        authors_table = AuthorsTable.new(
          [
            ArticleAuthor.new(name: 'Author', publications: [ required ]),
            ArticleAuthor.new(name: 'No Matching', publications: [a_doi])
          ]
        )

        author = authors_table.find(required)
        
        expect(author).to eq ['Author']
      end
    end

    context 'when the article is published by multiple authors' do
      it "returns all the authors' names" do
        required = a_doi
        authors_table = AuthorsTable.new(
          [
            ArticleAuthor.new(name: 'Not Author', publications: [a_doi, a_doi]),
            ArticleAuthor.new(name: 'Main Author', publications: [ required ]),
            ArticleAuthor.new(name: 'Co-Author 1', publications: [ required ]),
            ArticleAuthor.new(name: 'Co-Author 2', publications: [ required, a_doi ])
          ]
        )

        authors = authors_table.find(required)

        expected = [ 'Main Author', 'Co-Author 1', 'Co-Author 2' ]
        expect(authors).to eq expected
      end
    end
  end
end
