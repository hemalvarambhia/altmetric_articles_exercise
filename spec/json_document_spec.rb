require 'json_document'
require 'doi_helper'
require 'issn_helper'
describe 'JSON document' do
  include CreateDOI, CreateISSN

  describe '#content' do
    it "holds the document's content as a JSON data structure" do
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
end
