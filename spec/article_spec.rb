describe 'An article' do
  class Article
    attr_reader :doi

    def initialize(doi)
      @doi = doi 
    end

    def title
      'Electron Scattering by HCN'
    end
  end

  it 'stores its DOI' do
    doi = '10.1234/altmetric0'
    article = Article.new(doi)
    
    expect(article.doi).to eq doi
  end

  it 'stores any DOI passed to it' do
    doi = '10.1234/altmetric123'
    article = Article.new(doi)

    expect(article.doi).to eq doi
  end

  it 'stores the title' do
    title = 'Electron Scattering by HCN'
    article = Article.new(nil)
    expect(article.title).to eq title
  end
end
