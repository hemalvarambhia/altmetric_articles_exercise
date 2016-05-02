describe 'JSON document' do
  class JSONDocument
    def empty?
      true
    end
  end
  
  it 'is initially empty' do
    json_doc = JSONDocument.new
    
    expect(json_doc).to be_empty
  end
end
