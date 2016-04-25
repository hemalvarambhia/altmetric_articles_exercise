require 'csv'
describe 'Article File' do
  class ArticleFile
    def initialize(io, parser)
      @io = io
      @parser = parser
    end

    def each
      @io.each { |line| yield @parser.parse(line) }
    end
  end

  it 'parses off the DOI, title and ISSN' do
    io = StringIO.open do |content|
      content.puts '10.1234/altmetric001,About Physics,1234-5678'
      content.string
    end
    csv_line = [ '10.1234/altmetric001', 'About Physics', '1234-5678' ]
    parser = double :parser
    expect(parser).to receive(:parse).with csv_line
    file = ArticleFile.new(CSV.new(io), parser)

    file.each {}
  end
end