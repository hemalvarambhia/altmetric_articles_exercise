require 'csv'
describe 'Article CSV File spec' do
  class ArticleCSVFile
    def initialize(io, parser)
      @io = io
      @parser = parser
    end

    def read
      CSV.new(@io).each { |line| @parser.parse line }
    end
  end

  it 'parses off the DOI, title and ISSN' do
    io = StringIO.open do |content|
      content << '10.1234/altmetric001,About Physics,1234-5678'
      content.string
    end

    csv_line = [ '10.1234/altmetric001', 'About Physics', '1234-5678' ]
    parser = double :parser
    expect(parser).to receive(:parse).with csv_line

    file = ArticleCSVFile.new(io, parser)
    file.read
  end
end