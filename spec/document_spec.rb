require 'doi_helper'
require 'issn_helper'
require 'document'
describe 'Document' do
  include CreateDOI, CreateISSN
  before(:each) { @document = Document.new }

  it 'is initially empty' do
    expect(@document).to be_empty
  end

  describe '#<<' do
    it 'appends content to the document' do
      article = { 
        doi: a_doi,
        title: 'R-Matrix Theory',
        author: ['Author 1', 'Author 2'],
        journal: 'Journal of Physics',
        issn: an_issn
      }

      @document << article
    
      expect(@document).to include article
    end

    it 'adds articles in insertion order' do
      content = [
          { doi: a_doi, title: 'Article 1',
            author: ['Author 1'], journal: 'Biology', issn: an_issn },
          { doi: a_doi, title: 'Article 2',
            author: ['Author 2'], journal: 'Maths', issn: an_issn },
          { doi: a_doi, title: 'Article 3',
            author: ['Author 3'], journal: 'Nanotech', issn: an_issn }
      ]

      content.each { |element| @document << element }

      content.each_with_index do |expected_json, index|
        expect(@document[index]).to eq expected_json
      end
    end
  end
end