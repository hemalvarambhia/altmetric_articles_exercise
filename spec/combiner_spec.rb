require 'doi'
require 'issn'
require 'journal'

describe 'Combiner' do
  class Combiner
    def initialize(journals_file, articles_file, authors_file)
      @articles_file = articles_file
      @journals_file = journals_file
      @authors_file = authors_file
    end

    def each
      @articles_file.each do |article|       
        yield Hash[
                :doi, article[:doi],
                :title, article[:title],
                :journal, @journals_file.find(article[:issn]),
                :authors, @authors_file.find(article[:doi])
              ]
      end
    end
  end
  
  before(:each) do
    @journals_file = double(:journals_file)
    @authors_file = double(:authors_file)
  end
    
  it 'merges articles, journals and authors together' do
    articles_file = double(:articles_file)
    expect(articles_file)
      .to(receive(:each)
           .and_yield(                     
             {
               doi: DOI.new('10.5649/altmetric098'),
               title: 'Physics',
               issn: ISSN.new('1432-0456')
             }
           )
         )
    allow(@journals_file).to(
      receive(:find).with(ISSN.new('1432-0456'))
      .and_return(Journal.new('Journal', ISSN.new('1432-0456'))))
    allow(@authors_file).to(
      receive(:find).with(DOI.new('10.5649/altmetric098'))
      .and_return(['Author 1', 'Author 2', 'Author 3']))
    combiner = Combiner.new(
      @journals_file, articles_file, @authors_file)
      
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
