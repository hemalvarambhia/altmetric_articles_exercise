require 'author_json_doc'
require 'altmetric_file'
require 'doi'
require 'author_json_parser'
describe 'Parsing an author JSON document' do
  it 'reads off the author' do
    expected = [ 
      ArticleAuthor.new(
        name: 'Author 1', publications: [DOI.new('10.1234/altmetric0')]
      )
    ]
    path_to_author_json_doc = File.join(
      File.dirname(__FILE__), 'fixtures', 'one_author.json'
    )
    author_json_doc = AuthorJSONDoc.new(
      File.open(path_to_author_json_doc)
    )
    altmetric_file = AltmetricFile.new(author_json_doc, AuthorJSONParser)
    
    expect(altmetric_file.read).to eq expected
  end
end

