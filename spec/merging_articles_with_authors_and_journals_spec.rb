require 'doi'
require 'issn'

describe 'Processing an article' do
  class ArticlesProcessor
    def initialize(articles_store)
      @articles_store = articles_store
    end

    def process combiner, document = nil
      @articles_store.each {|article| document << combiner.combine(article) }
    end
  end

  it 'merges the article with its journal and author' do
    articles_store = double(:articles_store)
    line = [ DOI.new('10.1234/altmetric001'), 'Physics', ISSN.new('1234-5678') ]
    expect(articles_store).to(receive(:each).and_yield(line))
    processor = ArticlesProcessor.new(articles_store)
    combiner = double(:article_combiner)
    merged = {
        doi: DOI.new('10.1234/altmetric001'), title: 'Physics',
        issn: ISSN.new('1234-5678'), journal: 'Journal of Physics B',
        author: ['Author']
    }
    allow(combiner).to receive(:combine).with(line).and_return merged
    document = double(:document)
    expect(document).to receive(:<<).with(merged)

    processor.process combiner, document
  end
end