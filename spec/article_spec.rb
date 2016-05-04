require 'doi_helper'
describe 'Article' do
  include CreateDOI

  class Article
    def initialize(args)
      @doi = args[:doi]
    end

    def as_json
      { 'doi' => @doi }
    end
  end
 
  describe '#as_json' do
    it 'renders the DOI' do
      expected = a_doi
      article = Article.new(doi: expected)

      article_json = article.as_json
      expect(article_json).to have_key 'doi'
      expect(article_json['doi']).to eq expected
    end
  end
end