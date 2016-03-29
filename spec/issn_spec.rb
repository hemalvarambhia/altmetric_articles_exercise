describe 'ISSNs' do
  class ISSN
    Malformed = Class.new(Exception)
    
    def initialize(code)
      raise Malformed.new
    end
  end
  context 'when blank' do
    it 'is malformed' do
      expect{ ISSN.new('') }.to raise_error ISSN::Malformed 
    end
  end
end