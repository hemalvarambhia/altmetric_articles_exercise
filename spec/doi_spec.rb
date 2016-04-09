describe 'DOIs' do
  DOI = Class.new
  class DOI
    Malformed = Class.new(Exception)

    def initialize(doi)
      raise Malformed.new if doi.nil? or doi.length == 0
      raise Malformed.new unless doi.start_with? '10.'
      partition = doi.index('/')
      registrant = doi[3..partition - 1]
      raise Malformed.new if registrant.empty?
      object_id = doi[partition + 1..-1]
      raise Malformed.new if object_id.empty?
    end
  end

  context 'when it is blank' do
    it 'is malformed' do
      expect { DOI.new '' }.to raise_error DOI::Malformed
      expect { DOI.new nil }.to raise_error DOI::Malformed
    end
  end

  context 'when it has the correct registry' do
    it 'is well-formed' do
      expect { DOI.new '10.1234/altmetric123' }.not_to raise_error
    end
  end

  context 'when it has an invalid registry' do
    it 'is malformed' do
      expect { DOI.new '12.4123/altmetric333'}.to raise_error DOI::Malformed
    end
  end

  context 'when it has a registrant' do
    it 'is well-formed' do
      expect { DOI.new '10.1234/altmetric980'}.not_to raise_error
    end
  end

  context 'when it does not have a registrant' do
    it 'is malformed' do
      expect { DOI.new '10./altmetric777' }.to raise_error DOI::Malformed
    end
  end

  context 'when it does not have a object ID' do
    it 'is malformed' do
      expect { DOI.new '10.1254/'}.to raise_error DOI::Malformed
    end
  end

  context 'when it does have an object ID' do
    it 'is well-formed' do
      expect { DOI.new '10.5943/altmetric1983' }.not_to raise_error
    end
  end
end
