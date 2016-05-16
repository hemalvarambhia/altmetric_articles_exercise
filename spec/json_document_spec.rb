require 'json_document'
require 'doi_helper'
require 'issn_helper'
describe 'JSON document' do
  include CreateDOI, CreateISSN

  it 'is initially empty' do
    json_doc = JSONDocument.new
    
    expect(json_doc).to be_empty
  end

  describe '#content' do
    it "holds the document's content" do
      expected = { 
        doi: a_doi,
        title: 'Physics Article',
        issn: an_issn
      }
      json_doc = JSONDocument.new [ expected ]
      
      expect(json_doc.content).to eq [ expected ]
      expect(json_doc).not_to be_empty
    end
  end

  describe '#<<' do
    before :each do
      @doc = JSONDocument.new
    end

    it 'adds an article' do
      expected = { doi: a_doi, title: 'Chemistry', issn: an_issn }

      @doc << expected
  
      expect(@doc.content).to include expected
    end

    it 'adds articles in insertion order' do
      first = { doi: a_doi, title: 'Article 1', issn: an_issn, author: ['Author 1'] }
      second = { doi: a_doi, title: 'Article 2', issn: an_issn, author: ['Author 2'] }
      last = { doi: a_doi, title: 'Article 3', issn: an_issn, author: ['Author 3'] }
      [ first, second, last ].each do |element|
        @doc << element
      end

      expect(@doc.content[0]).to eq first
      expect(@doc.content[1]).to eq second
      expect(@doc.content[2]).to eq last
    end
  end
end
