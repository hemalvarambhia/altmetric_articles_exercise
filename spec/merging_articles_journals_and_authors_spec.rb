require 'rspec'
require 'ostruct'
require 'doi_helper'
require 'issn_helper'
require 'combined'
describe 'Combiner' do
  include CreateDOI, CreateISSN

  it 'publishes article merged with its journal and author to a document' do
    articles_table = double(:articles_table)
    journals_table = double(:journals_table)
    authors_table = double(:authors_table)
    document = double(:document)
    line = a_line
    expect(articles_table).to(
        receive(:join).with(journals_table, authors_table).and_return line
    )
    expect(document).to receive(:<<).with(an_article(line))
    combined = Combined.new(articles_table, journals_table, authors_table)

    combined.output_to(document)
  end

  def an_article(line)
    OpenStruct.new line
  end

  def a_line
    {
        doi: a_doi,
        title: 'Physics',
        issn: an_issn,
        journal: 'Journal of Physics A',
        authors: ['Author 1']
    }
  end
end