require 'rspec'
require 'article_author'
require 'doi'
describe 'Author' do
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

  describe '.==' do
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
  end

  def a_doi
    registrant = Array.new(4) { rand(0..9) }.join
    DOI.new("10.#{registrant}/altmetric#{rand(100000000)}")
  end
end