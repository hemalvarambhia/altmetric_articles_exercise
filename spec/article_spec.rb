require 'issn'
require 'journal'
require 'doi'
require 'article'

describe 'An article' do
  it 'stores the name and ISSN of the journal' do
    article = Article.new(
      journal: Journal.new('Journal of Physics B', ISSN.new('4321-8765'))
    )

    expect(article.journal).to eq 'Journal of Physics B'    
    expect(article.issn).to eq ISSN.new('4321-8765')
  end

  describe '#equals' do
    context 'when they both have the same DOI' do
      it 'marks them as being the same' do
        article = Article.new(doi: DOI.new('10.1234/altmetric123'))
        article_with_same_doi = Article.new(
          doi: DOI.new('10.1234/altmetric123')
        )
        
        expect(article).to eq article_with_same_doi
      end
    end

    context 'when they have different DOIs' do
      it 'marks them as not being the same' do
        article = Article.new(doi: DOI.new('10.1234/altmetric222'))
        with_different_doi = Article.new(
          doi: DOI.new('10.1234/altmetric999')
        )
        expect(article).not_to eq with_different_doi
      end
    end

    it 'is reflexive' do
      article = Article.new(doi: DOI.new('10.1234/altmetric345'))
      
      expect(article).to eq article
    end

    it 'is symmetric' do
      article_1 = Article.new(doi: DOI.new('10.1234/altmetric123'))
      article_2 = Article.new(doi: DOI.new('10.1234/altmetric123'))
      
      expect(article_1).to eq article_2
    end

    it 'is transitive' do
      article_1 = Article.new(doi: DOI.new('10.1234/altmetric541'))
      article_2 = Article.new(doi: DOI.new('10.1234/altmetric541'))
      article_3 = Article.new(doi: DOI.new('10.1234/altmetric541'))
      
      expect(article_1).to eq article_2
      expect(article_2).to eq article_3
      expect(article_3).to eq article_1
    end
  end
end
