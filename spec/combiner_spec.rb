require 'doi'
require 'issn'
require 'journal'

describe 'Combiner' do
  class Combiner
    def initialize(journals_file, authors_file)
      @journals_file = journals_file
      @authors_file = authors_file
    end

    def combine line
      Hash[
          :doi, line[0],
          :title, line[1],
          :issn, line[2],
          :journal, @journals_file.find(line[2]),
          :authors, @authors_file.find(line[0])
      ]
      end
    end
  
  before(:each) do
    @journals_file = double(:journals_file)
    @authors_file = double(:authors_file)
  end
    
  it 'merges articles, journals and authors together' do
    allow(@journals_file).to(
      receive(:find).with(ISSN.new('1432-0456'))
      .and_return('Journal'))
    allow(@authors_file).to(
      receive(:find).with(DOI.new('10.5649/altmetric098'))
      .and_return(['Author 1', 'Author 2', 'Author 3']))
    combiner = Combiner.new(@journals_file, @authors_file)

    line = [DOI.new('10.5649/altmetric098'), 'Physics', ISSN.new('1432-0456')]
    expect(combiner.combine(line)).to(
      eq(
        {
          doi: DOI.new('10.5649/altmetric098'),
          title: 'Physics',
          issn: ISSN.new('1432-0456'),
          journal: 'Journal',
          authors: [ 'Author 1', 'Author 2', 'Author 3' ]
        }
      ))
  end
end
