require 'json'
describe 'Author File' do
  class AuthorFile
    def initialize(io, parser)
      @io = io
      @parser = parser
    end

    def each
       @io.each { |author| yield @parser.parse(author) }
    end
  end

  it 'parses of the authors name and their publications' do
    authors = [{ 'name' => 'Author', 'articles' => ['10.2345/altmetric111'] }]
    io = StringIO.open do |content|
      content.puts authors.to_json
      content.string
    end
    parser = double(:parser)
    expect(parser).to(
        receive(:parse).with(
            { 'name' => 'Author', 'articles' => ['10.2345/altmetric111'] }))
    file = AuthorFile.new(JSON.parse(io), parser)

    file.each {}
  end
end