require 'doi_helper'
require 'author_json_doc'
describe 'An author JSON doc' do
  include CreateDOI

  it 'is empty by default' do
    author_json_doc = AuthorJSONDoc.new
    
    expect(author_json_doc).to be_empty
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

        expect(author_of_publication)
          .to eq ['W Heisenberg', 'E Schrodinger', 'P A M Dirac']
      end
    end

    context 'when there is no author of the given publication' do
      it 'returns no authors' do
        author_json_doc = given_an_author_doc_with(
          { 'name' => 'M Born', 'articles' => publications },
          { 'name' => 'W Pauli', 'articles' => publications },
          { 'name' => 'J von Neumann', 'articles' => publications }
        )
        
        authors_of_publication = author_json_doc.find @doi
        
        expect(authors_of_publication).to be_empty
      end
    end
  end

  def given_an_author_doc_with(*content)
    AuthorJSONDoc.new content
  end

  def publications_including(doi)
    publications + [ doi ]
  end

  def publications
    Array.new(3) { generate_doi }
  end
end
