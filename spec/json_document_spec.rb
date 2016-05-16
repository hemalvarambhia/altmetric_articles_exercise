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
      article = {
        doi: DOI.new('10.1234/altmetric658'), title: 'Physics Article',
        author: [ 'Author' ], journal: 'Science', issn: ISSN.new('6985-9743'),
      }
      json_doc = JSONDocument.new [ article ]

      expected = {
          doi: DOI.new('10.1234/altmetric658'), title: 'Physics Article',
          author: 'Author', journal: 'Science', issn: ISSN.new('6985-9743')
      }
      expect(json_doc.content).to(include(expected))
      expect(json_doc).not_to be_empty
    end

    context 'when an article has multiple authors' do
      it 'stores the authors as a comma-separated list' do
        article = {
            doi: a_doi,
            title: 'R-Matrix Method',
            author: ['Author 1', 'Co-Author 1', 'Co-Author 2' ],
            journal: 'Journal of Physics VB',
            issn: an_issn

        }
        json_doc = JSONDocument.new [ article ]

        expect(json_doc.content[0][:author]).to eq 'Author 1, Co-Author 1, Co-Author 2'
        expect(json_doc).not_to be_empty
      end
    end
  end

  describe '#<<' do
    before :each do
      @doc = JSONDocument.new
    end

    it 'adds an article' do
      article = {
          doi: DOI.new('10.6456/altmetric003'), title: 'Chemistry',
          author: [ 'Author' ], journal: 'Science', issn: ISSN.new('9685-2421')
      }

      @doc << article

      expected = {
          doi: DOI.new('10.6456/altmetric003'), title: 'Chemistry',
          author: 'Author', journal: 'Science', issn: ISSN.new('9685-2421')
      }
      expect(@doc.content).to include expected
    end

    it 'adds articles in insertion order' do
      content = [
          { doi: DOI.new('10.3459/altmetric001'), title: 'Article 1',
            author: ['Author 1'], journal: 'Biology', issn: ISSN.new('5094-2131') },
          { doi: DOI.new('10.5345/altmetric333'), title: 'Article 2',
            author: ['Author 2'], journal: 'Maths', issn: ISSN.new('2453-3258') },
          { doi: DOI.new('10.5555/altmetric555'), title: 'Article 3',
            author: ['Author 3'], journal: 'Nanotech', issn: ISSN.new('9326-3111') }
      ]

      content.each { |element| @doc << element }

      expected = [
          { doi: DOI.new('10.3459/altmetric001'), title: 'Article 1',
            author: 'Author 1', journal: 'Biology', issn: ISSN.new('5094-2131') },
          { doi: DOI.new('10.5345/altmetric333'), title: 'Article 2',
            author: 'Author 2', journal: 'Maths', issn: ISSN.new('2453-3258')  },
          { doi: DOI.new('10.5555/altmetric555'), title: 'Article 3',
            author: 'Author 3', journal: 'Nanotech', issn: ISSN.new('9326-3111') }
      ]
      actual_content = @doc.content
      expected.each_with_index do |expected_json, index|
        expect(actual_content[index]).to eq expected_json
      end
    end
  end
end
