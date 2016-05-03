require 'doi_helper'
require 'issn_helper'
describe 'CSV Document' do
  include CreateDOI, CreateISSN
  class CSVDocument
    def initialize(object = nil)
      @content = [ object ].compact
    end

    def <<(object)
      @content = [ object ]
    end

    def content
      @content.collect { |object| object.as_csv }
    end

    def empty?
      content.all? { |row| row.empty? }
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

      expect(csv_doc.content).to eq [ expected ]
      expect(csv_doc).not_to be_empty
    end
  end

  describe '#<<' do
    it 'appends to the current content' do
      expected = [ a_doi, 'Quantum Mechanics', an_issn ]
      csv_doc = CSVDocument.new
      article = double(:article, as_csv: expected)

      csv_doc << article

      expect(csv_doc.content).to eq [ expected ]
    end
  end
end