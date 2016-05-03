require 'ostruct'
require 'doi_helper'
require 'issn_helper'
describe 'JSON document' do
  include CreateDOI, CreateISSN

  class JSONDocument
    def initialize(articles = [])
      @content = articles
    end

    def <<(object)
      @content << object
    end

    def content
      @content.collect { |object| object.to_json }
    end
    
    def empty?
      @content.empty?
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
      allow(article).to receive(:to_json).and_return expected
      json_doc = JSONDocument.new [ article ]
      
      expect(json_doc.content).to eq [ expected ]
      expect(json_doc).not_to be_empty
    end
  end

  describe '#<<' do
    it 'adds an article' do
      json_doc = JSONDocument.new
      expected = { 'doi' => a_doi, 'title' => 'Chemistry', 'issn' => an_issn }
      article = double(:article)
      allow(article).to receive(:to_json).and_return expected
      json_doc << article
  
      expect(json_doc.content).to include expected
    end
  end
end
