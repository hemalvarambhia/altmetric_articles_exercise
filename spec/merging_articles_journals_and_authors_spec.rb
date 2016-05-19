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
    row = merged_row
    expect(articles_table).to(
      receive(:join).with(journals_table, authors_table)
      .and_return [row]
    )
    expect(document).to receive(:<<).with(row)
    combined = Combined.new(articles_table, journals_table, authors_table)

    combined.output_to(document)
  end

  def merged_row
    {
      doi: a_doi,
      title: 'Quantum Mechanics',
      issn: an_issn,
      journal: 'Nature',
      authors: ['Physicist']
    }
  end
end
