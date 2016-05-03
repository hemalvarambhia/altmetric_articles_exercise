describe 'CSV Document' do
  class CSVDocument
    def empty?
      true
    end
  end

  it 'is initially empty' do
    csv_doc = CSVDocument.new
    expect(csv_doc).to be_empty
  end
end