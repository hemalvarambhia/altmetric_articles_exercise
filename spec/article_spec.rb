describe 'An article' do
  class Article
    attr_reader :doi, :title

    def initialize(doi, title)
      @doi = doi 
      @title = title
    end
  end

  it 'stores its DOI' do
    doi = '10.1234/altmetric0'
    article = Article.new(doi, nil)
    
    expect(article.doi).to eq doi
  end

  it 'stores any DOI passed to it' do
    doi = '10.1234/altmetric123'
    article = Article.new(doi, nil)

    expect(article.doi).to eq doi
  end

  it 'stores the title' do
    title = 'Electron Scattering by HCN'
    article = Article.new(nil, title)

    expect(article.title).to eq title
  end

  it 'stores any title passed to it' do
    title = 'Chemistry Article'
    article = Article.new(nil, title)

    expect(article.title).to eq title
  end 
end
