describe 'An article' do
  class Article
    attr_reader :doi

    def initialize(doi)
      @doi = doi 
    end
  end

  it 'stores its DOI' do
    doi = '10.1234/altmetric0'
    article = Article.new(doi)
    expect(article.doi).to eq doi
  end

end
