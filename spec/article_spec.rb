describe 'An article' do
  class Article
    attr_reader :doi, :title, :author

    def initialize(doi, title, author)
      @doi = doi 
      @title = title
      @author = author
    end
  end

  it 'stores its DOI' do
    doi = '10.1234/altmetric0'
    article = Article.new(doi, nil, nil)
    
    expect(article.doi).to eq doi
  end

  it 'stores any DOI passed to it' do
    doi = '10.1234/altmetric123'
    article = Article.new(doi, nil, nil)

    expect(article.doi).to eq doi
  end

  it 'stores the title' do
    title = 'Electron Scattering by HCN'
    article = Article.new(nil, title, nil)

    expect(article.title).to eq title
  end

  it 'stores any title passed to it' do
    title = 'Chemistry Article'
    article = Article.new(nil, title, nil)

    expect(article.title).to eq title
  end 

  it 'stores the author' do
    author = ['Physicist']
    article = Article.new(nil, nil, author)
    
    expect(article.author).to eq author
  end

  it 'stores any author passed to it' do
    author = ['Chemist']
    article = Article.new(nil, nil, author)

    expect(article.author).to eq author
  end

  describe 'an article with multiple authors' do
    it 'stores all the authors' do
      authors = ['Author 1', 'Author 2', 'Author 3']
      article = Article.new(nil, nil, authors)
      
      expect(article.author).to eq authors
    end
  end
end
