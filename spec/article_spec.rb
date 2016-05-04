require 'doi_helper'
require 'issn_helper'
describe 'Article' do
  include CreateDOI, CreateISSN

  class Article
    def initialize(args)
      @doi = args[:doi]
      @issn = args[:issn]
      @title = args[:title]
    end

    def as_json
      { 'doi' => @doi, 'issn' => @issn, 'title' => @title }
    end
  end
 
  describe '#as_json' do
    it 'renders the DOI' do
      expected = a_doi
      article = Article.new(doi: expected)

      article_json = article.as_json
      expect(article_json).to include('doi' => expected)
    end

    it 'renders the ISSN' do
      expected = an_issn
      article = Article.new(issn: expected)
      
      article_json = article.as_json
      expect(article_json).to include('issn' => expected)
    end

    it 'renders the title' do
      expected = 'The R-Matrix Method'
      article = Article.new(title: expected)      

      article_json = article.as_json
      expect(article_json).to include('title' => expected)
    end
  end
end