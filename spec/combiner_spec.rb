require 'doi'
require 'issn'
require 'journal'

describe 'Combiner' do
  class Combiner
    def initialize(articles_file, journals_file, authors_file)
      @articles_file = articles_file
      @journals_file = journals_file
      @authors_file = authors_file
    end

    def each
      merged = @articles_file.read.collect do |article|
        the_article = { doi: article[:doi], title: article[:title] }
        the_article.merge(
          journal: @journals_file.find(article[:issn]),
          authors: @authors_file.find(article[:doi])
        )
      end

      merged.each { |merge| yield merge }
    end
  end
  
  context 'when there is a journal and authors(s)' do
    before(:each) do
      @journals_file = double(:journals_file)
      @authors_file = double(:authors_file)
    end
    it 'merges them together with the article' do
      articles_file = double(:articles_file)
      expect(articles_file).to(
        receive(:read).and_return(
        [
          {
            doi: DOI.new('10.5649/altmetric098'),
            title: 'Physics',
            issn: ISSN.new('1432-0456')
          }
        ])
      )
      allow(@journals_file).to(
        receive(:find).with(ISSN.new('1432-0456'))
        .and_return(Journal.new('Journal', ISSN.new('1432-0456')))
      )
      allow(@authors_file).to(
        receive(:find).with(DOI.new('10.5649/altmetric098'))
        .and_return(['Author 1', 'Author 2', 'Author 3'])
      )
      combiner = Combiner.new(
        articles_file, @journals_file, @authors_file
      )
                              
      expect { |b| combiner.each(&b) }.to(
        yield_successive_args(
          {
            doi: DOI.new('10.5649/altmetric098'),
            title: 'Physics',
            journal: Journal.new('Journal', ISSN.new('1432-0456')),
            authors: [ 'Author 1', 'Author 2', 'Author 3' ]
          }
        ))
    end
  end
end
