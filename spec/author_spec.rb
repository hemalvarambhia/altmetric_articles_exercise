require 'rspec'
require 'author'
require 'doi'
describe 'Author' do
  it 'stores their name' do
    author = Author.new(name: 'Author')
    expect(author.name).to eq 'Author'
  end

  it 'stores their publications' do
    doi_1 = DOI.new('10.1234/altmetric2394')
    doi_2 = DOI.new('10.7808/altmetric6333')
    author = Author.new(name: nil, publications: [doi_1, doi_2])
    expect(author.publications).to eq [doi_1, doi_2]
  end

  describe '#author_of?' do
    it 'confirms that an author published an article' do
      doi_1 = DOI.new('10.0011/altmetric9999')
      doi_2 = DOI.new('10.7688/altmetric6512')
      author = Author.new(name: nil, publications: [doi_1, doi_2])

      expect(author).to be_author_of doi_1
    end

    it 'confirms that an author did not publish an article' do
      doi_1 = DOI.new('10.0011/altmetric9999')
      doi_2 = DOI.new('10.7688/altmetric6512')
      doi_3 = DOI.new('10.2211/altmetric1983')
      author = Author.new(name: nil, publications: [doi_1, doi_2])

      expect(author).not_to be_author_of doi_3
    end
  end
end