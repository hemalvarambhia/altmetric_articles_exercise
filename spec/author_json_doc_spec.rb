require 'doi_helper'
require 'forwardable'
describe 'An author JSON doc' do
  include CreateDOI
  class AuthorJSONDoc
    extend Forwardable
    def_delegator :@content, :empty?
    
    def initialize content = []
      @content = content
    end

    def find doi
      matching_author = @content.select { |author| published_by?(author, doi) }
      matching_author.collect { |author| author['name'] }
    end

    private

    def published_by?(author, doi)
      author['articles'].include?(doi)
    end
  end

  it 'is empty by default' do
    author_json_doc = AuthorJSONDoc.new
    
    expect(author_json_doc).to be_empty
  end

  describe '#find' do
    before(:each) { @doi = generate_doi }

    context 'when the author published only the given article' do
       it 'returns their name' do
         content = [
             {'name' => 'P A M Dirac', 'articles' => [@doi]}
         ]
         author_json_doc = AuthorJSONDoc.new content

         author_of_publication = author_json_doc.find(@doi)

         expect(author_of_publication).to eq ['P A M Dirac']
       end
    end

    context 'when the matching author has more than one publication' do
      it 'returns their name' do
        content = [
            {
                'name' => 'W Heisenberg',
                'articles' => publications_including(@doi),
            }
        ]
        author_json_doc = AuthorJSONDoc.new content

        author_of_publication = author_json_doc.find(@doi)

        expect(author_of_publication).to eq ['W Heisenberg']
      end
    end

    context 'when more than one author published the article' do
      it "returns every author's name" do
        content = [
            {
                'name' => 'W Heisenberg',
                'articles' => publications_including(@doi),
            },
            {
                'name' => 'E Schrodinger',
                'articles' => publications_including(@doi),
            },
            {
                'name' => 'P A M Dirac',
                'articles' => publications_including(@doi),
            }
        ]
        author_json_doc = AuthorJSONDoc.new content

        author_of_publication = author_json_doc.find(@doi)

        expect(author_of_publication)
          .to eq ['W Heisenberg', 'E Schrodinger', 'P A M Dirac']
      end
    end

    context 'when there is no author of the given publication' do
      it 'returns no authors' do
        content = [
          { 'name' => 'M Born', 'articles' => publications },
          { 'name' => 'W Pauli', 'articles' => publications },
          { 'name' => 'J von Neumann', 'articles' => publications }
        ]
        author_json_doc = AuthorJSONDoc.new content
        
        authors_of_publication = author_json_doc.find @doi
        
        expect(authors_of_publication).to be_empty
      end
    end
    
  end

  def publications
    Array.new(3) { generate_doi }
  end

  def publications_including(doi)
    Array.new(3) { generate_doi } + [ doi ]
  end
end
