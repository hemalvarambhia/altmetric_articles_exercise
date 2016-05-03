require 'rspec'
require 'doi'
require 'doi_helper'
require 'issn'
require 'issn_helper'
describe 'Combiner' do
  include CreateDOI, CreateISSN

  class Combined
    def initialize(articles, journals, authors)
      @articles = articles
      @journals = journals
      @authors = authors
    end

    def output_to document
       document << @articles.join(@journals, @authors)
    end
  end

  it 'publishes article merged with its journal and author to a document' do
    articles_table = double(:articles_table)
    journals_table = double(:journals_table)
    authors_table = double(:authors_table)
    document = double(:document)
    line = a_line
    expect(articles_table).to(
        receive(:join).with(journals_table, authors_table).and_return line
    )
    expect(document).to receive(:<<).with(line)
    combined = Combined.new(articles_table, journals_table, authors_table)

    combined.output_to(document)
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