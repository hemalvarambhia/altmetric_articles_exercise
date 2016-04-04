describe 'DOIs' do
  DOI = Class.new
  class DOI
    Malformed = Class.new(Exception)

    def initialize(doi)
      raise Malformed.new
    end
  end

  context 'when it is blank' do
    it 'is malformed' do
      expect { DOI.new('') }.to raise_error DOI::Malformed
      expect { DOI.new nil }.to raise_error DOI::Malformed
    end
  end
end