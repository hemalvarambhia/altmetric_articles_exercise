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
      expected = { doi: a_doi, title: 'R-Matrix Method', issn: an_issn }
      csv_doc = CSVDocument.new expected

      expect(csv_doc.content).to include expected.values
      expect(csv_doc).not_to be_empty
    end
  end

  describe '#<<' do
    before(:each) { @doc = CSVDocument.new }

    it 'appends to the current content' do
      expected = { doi: a_doi, title: 'Quantum Mechanics', issn: an_issn }

      @doc << expected

      expect(@doc.content).to include expected.values
    end

    it 'appends in insertion order' do
      first = { doi: a_doi, title: 'Article 1', issn: an_issn }
      second =  { doi: a_doi, title: 'Article 2', issn: an_issn }
      last =  { doi: a_doi, title: 'Article 3', issn: an_issn }
      [first, second, last].each do |article|
         @doc << article
      end

      expect(@doc.content[0]).to eq first.values
      expect(@doc.content[1]).to eq second.values
      expect(@doc.content[2]).to eq last.values
    end
  end
end
