require 'rspec'

describe 'Altmetric File' do
  class AltmetricFile
    def initialize(io, parser)
      @io = io
      @parser = parser
    end

    def read
      @parser.parse(@io.content)
    end
  end

  it 'should delegate reading off the content to a parser' do
    content = 'content'
    io = double(:file)
    expect(io).to receive(:content).and_return content
    parser = double(:parser)
    expect(parser).to receive(:parse).with(content)
    altmetric_file = AltmetricFile.new(io, parser)

    altmetric_file.read
  end
end