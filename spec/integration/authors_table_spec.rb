require 'altmetric_file'
require 'author_json_doc'
require 'author_json_parser'
require 'authors_table'
describe 'AuthorsTable' do
  it 'reads off the authors of an article correctly' do
    path_to_json_doc = File.join(
      File.dirname(__FILE__), 'sample_docs', 'one_author.json'
    )
    authors_json_doc = AuthorJSONDoc.new(File.open(path_to_json_doc))
    authors_table = AuthorsTable.from AltmetricFile.new(authors_json_doc, AuthorJSONParser)
    doi = DOI.new '10.1234/altmetric0'

    expect(authors_table.find(doi)).to eq [ 'Author 1' ]
  end
end