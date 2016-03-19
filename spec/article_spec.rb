describe 'An article' do
  class Article
    attr_reader :doi, :title, :author, :issn, :journal

    def initialize(args)
      @doi = args[:doi] 
      @title = args[:title]
      @author = args[:author]
      @issn = args[:issn]
      @journal = args[:journal]
    end

    def ==(other)
      doi == other.doi
    end
  end

  it 'stores its DOI' do
    doi = '10.1234/altmetric0'
    article = Article.new(doi: doi)
    
    expect(article.doi).to eq doi
  end

  it 'stores any DOI passed to it' do
    doi = '10.1234/altmetric123'
    article = Article.new(doi: doi)

    expect(article.doi).to eq doi
  end

  it 'stores the title' do
    title = 'Electron Scattering by HCN'
    article = Article.new(title: title)

    expect(article.title).to eq title
  end

  it 'stores any title passed to it' do
    title = 'Chemistry Article'
    article = Article.new(title: title)

    expect(article.title).to eq title
  end 

  it 'stores the author' do
    author = ['Physicist']
    article = Article.new(author: author)
    
    expect(article.author).to eq author
  end

  it 'stores any author passed to it' do
    author = ['Chemist']
    article = Article.new(author: author)

    expect(article.author).to eq author
  end

  describe 'an article with multiple authors' do
    it 'stores all the authors' do
      authors = ['Author 1', 'Author 2', 'Author 3']
      article = Article.new(author: authors)
      
      expect(article.author).to eq authors
    end
  end

  it 'stores its ISSN' do
    issn = '1234-5678'
    article = Article.new(issn: issn)
    
    expect(article.issn).to eq issn
  end

  it 'stores any ISSN passed to it' do
    issn = '2345-6789'
    article = Article.new(issn: issn)
    
    expect(article.issn).to eq issn
  end

  it 'stores the journal it was published in' do
    journal = 'Journal of Physics B'
    article = Article.new(journal: journal)
    
    expect(article.journal).to eq journal
  end

  it 'stores any journal passed to it' do
    journal = 'Physical Review Letters'
    article = Article.new(journal: journal)
    
    expect(article.journal).to eq journal
  end

  describe 'equating two articles' do
    context 'when they both have the same DOI' do
      it 'marks them as being the same' do
        article = Article.new(doi: '10.1234/altmetric123')
        article_with_same_doi = Article.new(
          doi: '10.1234/altmetric123'
        )
        
        expect(article).to eq article_with_same_doi
      end
    end

    context 'when they have different DOIs' do
      it 'marks them as not being the same' do
        article = Article.new(doi: '10.1234/altmetric222')
        with_different_doi = Article.new(
          doi: '10.1234/altmetric999'
        )
        expect(article).not_to eq with_different_doi
      end
    end

    it 'is reflexive' do
      article = Article.new(doi: '10.1234/altmetric345')
      
      expect(article).to eq article
    end

    it 'is symmetric' do
      article_1 = Article.new(doi: '10.1234/altmetric123')
      article_2 = Article.new(doi: '10.1234/altmetric123')
      
      expect(article_1).to eq article_2
    end
  end
end
