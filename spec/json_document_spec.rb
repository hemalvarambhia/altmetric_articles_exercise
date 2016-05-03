require 'ostruct'
require 'doi_helper'
require 'issn_helper'
describe 'JSON document' do
  include CreateDOI, CreateISSN

  class JSONDocument
    def initialize(article = nil)
      @content = article
    end

    def content
      [ @content.to_json ]
    end
    
    def empty?
      @content.nil?
    end
  end
  
  it 'is initially empty' do
    json_doc = JSONDocument.new
    
    expect(json_doc).to be_empty
  end

  describe '#content' do
    it "holds the document's content" do
      expected = {
        'doi' => a_doi,
        'title' => 'Physics Article',
        'issn' => an_issn
      }
      article = double(:article)
      expect(article).to receive(:to_json).and_return expected
      json_doc = JSONDocument.new article
      
      expect(json_doc.content).to eq [ expected ]
      expect(json_doc).not_to be_empty
    end
  end
end
