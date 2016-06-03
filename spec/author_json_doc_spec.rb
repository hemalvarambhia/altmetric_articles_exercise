require 'doi_helper'
describe 'An author JSON doc' do
  include CreateDOI
  class AuthorJSONDoc
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

  describe '#find' do
    before(:each) { @doi = generate_doi }

    context 'when the author published only the given article' do
       it 'returns their name' do
         author_json_doc = given_an_author_doc_with(
             { 'name' => 'P A M Dirac', 'articles' => [@doi] }
         )

         author_of_publication = author_json_doc.find(@doi)

         expect(author_of_publication).to eq ['P A M Dirac']
       end
    end

    context 'when the matching author has more than one publication' do
      it 'returns their name' do
        author_json_doc = given_an_author_doc_with(
            {
                'name' => 'W Heisenberg',
                'articles' => publications_including(@doi),
            }
        )

        author_of_publication = author_json_doc.find(@doi)

        expect(author_of_publication).to eq ['W Heisenberg']
      end
    end

    context 'when more than one author published the article' do
      it "returns every author's name" do
        author_json_doc = given_an_author_doc_with(
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
        )

        author_of_publication = author_json_doc.find(@doi)

        expect(author_of_publication).to eq ['W Heisenberg', 'E Schrodinger', 'P A M Dirac']
      end
    end
  end

  def given_an_author_doc_with(*content)
    AuthorJSONDoc.new content
  end

  def publications_including(doi)
    Array.new(3) { generate_doi } + [ doi ]
  end
end