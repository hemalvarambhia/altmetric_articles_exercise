require 'doi_helper'
describe 'An author JSON doc' do
  include CreateDOI
  class AuthorJSONDoc
    def initialize content = []
      @content = content
    end

    def find doi
      matching_author = @content.detect { |author| author['articles'].include?(doi) }
      [ matching_author['name'] ]
    end
  end

  describe '#read' do
    context 'when the author published only the given article' do
       it 'returns their name' do
         doi = generate_doi
         content = [
             {'name' => 'P A M Dirac', 'articles' => [doi]}
         ]
         author_json_doc = AuthorJSONDoc.new content

         expect(author_json_doc.find(doi)).to eq ['P A M Dirac']
       end
    end

    context 'when the matching author has more than one publication' do
      it 'returns their name' do
        doi = generate_doi
        content = [
            {
                'name' => 'W Heisenberg',
                'articles' => some_publications_including(doi),
            }
        ]
        author_json_doc = AuthorJSONDoc.new content

        author_of_publication = author_json_doc.find(doi)
        expect(author_of_publication).to eq ['W Heisenberg']
      end
    end
  end

  def some_publications_including(doi)
    Array.new(3) { generate_doi } + [ doi ]
  end
end