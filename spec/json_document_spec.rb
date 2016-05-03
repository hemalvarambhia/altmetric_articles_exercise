require 'ostruct'
require 'doi_helper'
require 'issn_helper'
describe 'JSON document' do
  include CreateDOI, CreateISSN

  class JSONDocument
    extend Forwardable
    def_delegators :@content, :<<, :empty?
    def initialize(articles = [])
      @content = articles
    end

    def content
      @content.collect { |object| object.as_json }
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
      allow(article).to receive(:as_json).and_return expected
      json_doc = JSONDocument.new [ article ]
      
      expect(json_doc.content).to eq [ expected ]
      expect(json_doc).not_to be_empty
    end
  end

  describe '#<<' do
    before :each do
      @doc = JSONDocument.new
    end

    it 'adds an article' do
      expected = { 'doi' => a_doi, 'title' => 'Chemistry', 'issn' => an_issn }
      article = double(:article)
      allow(article).to receive(:as_json).and_return expected

      @doc << article
  
      expect(@doc.content).to include expected
    end

    it 'adds articles in insertion order' do
      first = { 'doi' => a_doi, 'title' => 'Article 1', 'issn' => an_issn }
      second = { 'doi' => a_doi, 'title' => 'Article 2', 'issn' => an_issn }
      last = { 'doi' => a_doi, 'title' => 'Article 3', 'issn' => an_issn }
      [ first, second, last ].each do |element|
        an_article = double(:article, :as_json => element)
        @doc << an_article
      end

      expect(@doc.content[0]).to eq first
      expect(@doc.content[1]).to eq second
      expect(@doc.content[2]).to eq last
    end
  end
end
