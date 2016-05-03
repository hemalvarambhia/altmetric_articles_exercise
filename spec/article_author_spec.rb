require 'rspec'
require 'article_author'
require 'doi_helper'
describe 'Author' do
  include CreateDOI

  it 'stores their name' do
    author = ArticleAuthor.new(name: 'Author')
    expect(author.name).to eq 'Author'
  end

  it 'stores their publications' do
    doi_1, doi_2 = a_doi, a_doi
    author = ArticleAuthor.new(name: nil, publications: [doi_1, doi_2])

    expect(author.publications).to eq [doi_1, doi_2]
  end

  it 'does not store duplicate publications' do
    doi_1, doi_2 = a_doi, a_doi
    author = ArticleAuthor.new(name: nil, publications: [doi_1, doi_1, doi_2])

    expect(author.publications).to eq [doi_1, doi_2]
  end

  describe '#author_of?' do
    it 'confirms that an author published an article' do
      doi_1, doi_2 = a_doi, a_doi
      author = ArticleAuthor.new(name: nil, publications: [doi_1, doi_2])

      expect(author).to be_author_of doi_1
    end

    it 'confirms that an author did not publish an article' do
      doi_1, doi_2, doi_3 = a_doi, a_doi, a_doi
      author = ArticleAuthor.new(name: nil, publications: [doi_1, doi_2])

      expect(author).not_to be_author_of doi_3
    end
  end

  describe '#==' do
    context 'when two authors have the same name and publications' do
      it 'confirms them as one and the same' do
        publications = [a_doi, a_doi]
        author = ArticleAuthor.new(name: 'Scientist', publications: publications)
        same_author = ArticleAuthor.new(name: 'Scientist', publications: publications)

        expect(author).to eq same_author
      end
    end

    context 'when two authors just have different names' do
      it 'confirms them as not being the same' do
        publications = [a_doi, a_doi]
        author = ArticleAuthor.new(name: 'Chemist', publications: publications)
        with_different_name = ArticleAuthor.new(name: 'Biologist', publications: publications)

        expect(author).not_to eq with_different_name
      end
    end

    context 'when the authors have the same name but different publications' do
      it 'confirms them as not being the same' do
        author = ArticleAuthor.new(name: 'Paul Dirac', publications: [a_doi, a_doi, a_doi])
        with_different_publications =
            ArticleAuthor.new(name: 'Paul Dirac', publications: [a_doi, a_doi, a_doi])

        expect(author).not_to eq with_different_publications
      end
    end

    it 'is reflexive' do
      author = ArticleAuthor.new(name: 'Wolfgang Pauli', publications: [a_doi, a_doi])

      expect(author).to eq author
    end

    it 'is symmetric' do
      publications = Array.new(3) { a_doi }
      author = ArticleAuthor.new(name: 'Albert Einstein', publications: publications)
      same_author = ArticleAuthor.new(name: 'Albert Einstein', publications: publications)

      expect(author).to eq same_author
      expect(same_author).to eq author
    end

    it 'is transitive' do
      publications = Array.new(4) { a_doi }
      author_1 = ArticleAuthor.new(name: 'Werner Heisenberg', publications: publications)
      author_2 = ArticleAuthor.new(name: 'Werner Heisenberg', publications: publications)
      author_3 = ArticleAuthor.new(name: 'Werner Heisenberg', publications: publications)

      expect(author_1).to eq author_2
      expect(author_2).to eq author_3
      expect(author_3).to eq author_1
    end
  end
end