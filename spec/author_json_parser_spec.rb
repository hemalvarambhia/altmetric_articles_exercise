require 'article_author_helper'
require 'author_json_parser'
describe 'Author JSON Parser' do
  include CreateAuthor
  
  it 'parses the author from the JSON element' do
    author_json = {
      'name' => 'Author',
      'articles' => [ '10.6980/altmetric324', '10.7234/altmetric000' ]
    }
    expected = an_author(
      name: 'Author',
      publications:
        [ DOI.new('10.6980/altmetric324'), DOI.new('10.7234/altmetric000') ]
    )

    author = AuthorJSONParser.parse(author_json)

    expect(author).to eq expected
  end

  it 'parses the author from any JSON element' do
    author_json = {
      'name' => 'Another',
      'articles' => [ '10.8100/altmetric222', '10.9786/altmetric999' ]
    }
    expected = an_author(
      name: 'Another',
      publications: 
        [ DOI.new('10.8100/altmetric222'), DOI.new('10.9786/altmetric999') ]
    )

    author = AuthorJSONParser.parse(author_json)
    
    expect(author).to eq expected
  end
end
