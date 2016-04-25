require 'csv'
describe 'Journal CSV File' do
  class JournalCSVFile
    def initialize(io, parser)
      @io = io
      @parser = parser
    end

    def read
      @io.each { |line| @parser.parse(line) }
    end
  end

  it 'parses off the ISSN and title' do
    io = StringIO.open do |content|
      content << '8964-5695,Journal of Physics B'
      content.string
    end
    line = [ '8964-5695', 'Journal of Physics B' ]
    parser = double(:parser)
    expect(parser).to receive(:parse).with(line)
    file = JournalCSVFile.new(CSV.new(io), parser)

    file.read
  end
end