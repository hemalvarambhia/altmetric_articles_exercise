require 'csv_document'
require 'doi_helper'
require 'issn_helper'
describe 'CSV Document' do
  include CreateDOI, CreateISSN

  it 'is initially empty' do
    csv_doc = CSVDocument.new

    expect(csv_doc).to be_empty
  end

  describe '#content' do
    it 'stores the content' do
      expected = [ a_doi, 'R-Matrix Method', an_issn ]
      article = double(:article, as_csv: expected)
      csv_doc = CSVDocument.new article

      expect(csv_doc.content).to eq [ expected ]
      expect(csv_doc).not_to be_empty
    end
  end

  describe '#<<' do
    before(:each) { @doc = CSVDocument.new }

    it 'appends to the current content' do
      expected = [ a_doi, 'Quantum Mechanics', an_issn ]
      article = double(:article, as_csv: expected)

      @doc << article

      expect(@doc.content).to eq [ expected ]
    end

    it 'appends in insertion order' do
      first = [ a_doi, 'Article 1', an_issn ]
      second = [ a_doi, 'Article 2', an_issn ]
      last = [ a_doi, 'Article 3', an_issn ]
      [first, second, last].each do |expected_row|
         article = double(:article, as_csv: expected_row)
         @doc << article
      end

      expect(@doc.content[0]).to eq first
      expect(@doc.content[1]).to eq second
      expect(@doc.content[2]).to eq last
    end
  end
end
