require 'doi_helper'
describe 'An author JSON doc' do
  include CreateDOI
  class AuthorJSONDoc
    def initialize content = []

    end

    def find doi
      [ 'P A M Dirac' ]
    end
  end
  describe '#read' do
    context 'when the author is in the document' do
       it 'returns their name' do
         doi = generate_doi
         content = [
             {'name' => 'P A M Dirac', 'articles' => [ doi ]}
         ]
         author_json_doc = AuthorJSONDoc.new content

         expect(author_json_doc.find(doi)).to eq ['P A M Dirac']
       end
    end
  end
end