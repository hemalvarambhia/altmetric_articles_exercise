describe 'An article' do
  class Article
    attr_reader :doi, :title, :author

    def initialize(doi, title, author, issn)
      @doi = doi 
      @title = title
      @author = author
      @issn = issn
    end

    def issn
      @issn
    end
  end

  it 'stores its DOI' do
    doi = '10.1234/altmetric0'
    article = Article.new(doi, nil, nil, nil)
    
    expect(article.doi).to eq doi
  end

  it 'stores any DOI passed to it' do
    doi = '10.1234/altmetric123'
    article = Article.new(doi, nil, nil, nil)

    expect(article.doi).to eq doi
  end

  it 'stores the title' do
    title = 'Electron Scattering by HCN'
    article = Article.new(nil, title, nil, nil)

    expect(article.title).to eq title
  end

  it 'stores any title passed to it' do
    title = 'Chemistry Article'
    article = Article.new(nil, title, nil, nil)

    expect(article.title).to eq title
  end 

  it 'stores the author' do
    author = ['Physicist']
    article = Article.new(nil, nil, author, nil)
    
    expect(article.author).to eq author
  end

  it 'stores any author passed to it' do
    author = ['Chemist']
    article = Article.new(nil, nil, author, nil)

    expect(article.author).to eq author
  end

  describe 'an article with multiple authors' do
    it 'stores all the authors' do
      authors = ['Author 1', 'Author 2', 'Author 3']
      article = Article.new(nil, nil, authors, nil)
      
      expect(article.author).to eq authors
    end
  end

  it 'stores its ISSN' do
    issn = '1234-5678'
    article = Article.new(nil, nil, nil, issn)
    
    expect(article.issn).to eq issn
  end

  it 'stores any ISSN passed to it' do
    issn = '2345-6789'
    article = Article.new(nil, nil, nil, issn)
    
    expect(article.issn).to eq issn
  end
end
