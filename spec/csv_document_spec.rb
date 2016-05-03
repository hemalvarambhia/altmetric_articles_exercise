require 'doi_helper'
require 'issn_helper'
describe 'CSV Document' do
  include CreateDOI, CreateISSN
  class CSVDocument
    def initialize(object = nil)
      @content = object
    end

    def content
      @content.as_csv
    end

    def empty?
      @content.nil?
    end
  end

  it 'is initially empty' do
    csv_doc = CSVDocument.new

    expect(csv_doc).to be_empty
  end

  describe '#content' do
    it 'stores the content' do
      expected = [ a_doi, 'R-Matrix Method', an_issn ]
      article = double(:article, as_csv: expected)
      csv_doc = CSVDocument.new article

      expect(csv_doc.content).to eq expected
      expect(csv_doc).not_to be_empty
    end
  end
end