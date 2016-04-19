require 'rspec'
require 'doi'
require 'issn'
describe 'Merging one article with its journal and author' do
  class TableMerger
    def initialize(articles, journals, authors)
      @articles = articles
      @journals = journals
      @authors = authors
    end

    def merge document
       document << @articles.merge(@journals, @authors)
    end
  end

  it 'merges them and publishes them to a document' do
    articles_table = double(:articles_table)
    journals_table = double(:journals_table)
    authors_table = double(:authors_table)
    document = double(:document)
    line = a_line
    expect(articles_table).to(
        receive(:merge).with(journals_table, authors_table).and_return line
    )
    expect(document).to receive(:<<).with(line)
    merger = TableMerger.new(articles_table, journals_table, authors_table)

    merger.merge(document)
  end

  def a_line
    {
        doi: DOI.new('10.1234/altmetric001'),
        title: 'Physics',
        issn: ISSN.new('1234-5678'),
        journal: 'Journal of Physics A',
        authors: ['Author 1']
    }
  end
end