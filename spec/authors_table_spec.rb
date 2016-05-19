require 'authors_table'
require 'article_author'
require 'doi_helper'

describe 'Authors table' do
  include CreateDOI
  
  describe '#find' do
    context 'when there are no authors of an article' do
      it 'returns no authors' do
        required = a_doi
        authors_table = AuthorsTable.new(
          [ an_author_of(a_doi), an_author_of(a_doi) ]
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
            an_author(name: 'Author', publications: [ required ]),
            an_author_of(a_doi)
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
            an_author_of(a_doi, a_doi),
            an_author(name: 'Main Author', publications: [ required ]),
            an_author(name: 'Co-Author 1', publications: [ required ]),
            an_author(name: 'Co-Author 2', publications: [ required, a_doi ])
          ]
        )

        authors = authors_table.find(required)

        expected = [ 'Main Author', 'Co-Author 1', 'Co-Author 2' ]
        expect(authors).to eq expected
      end
    end
  end

  def an_author(args)
    ArticleAuthor.new args
  end

  def an_author_of(*publications)
    an_author(name: nil, publications: publications)
  end
end
