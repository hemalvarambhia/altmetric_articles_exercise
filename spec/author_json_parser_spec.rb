require 'ostruct'
require 'doi'

describe 'Author JSON Parser' do
  class AuthorJSONParser
    def self.parse(author_json)
       OpenStruct.new(
         name: author_json['name'],
         publications: author_json['articles'].map { |doi| DOI.new doi }
       )
    end    
  end

  it 'parses the author from the JSON element' do
    author_json = {
      'name' => 'Author',
      'articles' => [ '10.6980/altmetric324', '10.7234/altmetric000' ]
    }
    expected = author_with(
      name: 'Author',
      publications:
        [ DOI.new('10.6980/altmetric324'), DOI.new('10.7234/altmetric000') ]
    )

    expect(AuthorJSONParser.parse(author_json)).to eq expected
  end

  it 'parses the author from any JSON element' do
    author_json = {
      'name' => 'Another',
      'articles' => [ '10.8100/altmetric222', '10.9786/altmetric999' ]
    }
    expected = author_with(
      name: 'Another',
      publications: 
        [ DOI.new('10.8100/altmetric222'), DOI.new('10.9786/altmetric999') ]
    )

    expect(AuthorJSONParser.parse(author_json)).to eq expected
  end

  def author_with(attributes)
    OpenStruct.new attributes
  end
end