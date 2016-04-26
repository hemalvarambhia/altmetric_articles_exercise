require 'ostruct'
require 'doi'

describe 'Author JSON Parser' do
  class AuthorJSONParser
    def self.parse(author_json)
       OpenStruct.new(
         name: 'Author',
         publications: [
           DOI.new('10.6980/altmetric324'), 
           DOI.new('10.7234/altmetric000')
         ]
       )
    end    
  end

  it 'parses the author from the JSON element' do
    author_json = {
      'name' => 'Author',
      'articles' => [ '10.6980/altmetric324', '10.7234/altmetric000' ]
    }

    expect(AuthorJSONParser.parse(author_json)).to(
      eq(
        OpenStruct.new(
          name: 'Author',
          publications: [
            DOI.new('10.6980/altmetric324'),
            DOI.new('10.7234/altmetric000')
          ]
        )
      )
    ) 
  end
end