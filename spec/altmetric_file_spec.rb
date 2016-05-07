require 'rspec'
require 'altmetric_file'
describe 'Altmetric File' do
  it 'should delegate reading off the content to a parser' do
    content = 'content'
    document = double(:document)
    expect(document).to receive(:read).and_return [ content ]
    parser = double(:parser)
    expect(parser).to receive(:parse).with(content)
    altmetric_file = AltmetricFile.new(document, parser)

    altmetric_file.read
  end
end
