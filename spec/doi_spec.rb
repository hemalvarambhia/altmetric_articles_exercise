describe 'DOIs' do
  DOI = Class.new
  class DOI
    Malformed = Class.new(Exception)

    def initialize(doi)
      raise Malformed.new if doi.nil? or doi.length == 0
      raise Malformed.new unless doi[0..2] == '10.'
      raise Malformed.new if doi[3..-1].empty?
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
      expect { DOI.new '10.1234' }.not_to raise_error
    end
  end

  context 'when it has an invalid registry' do
    it 'is malformed' do
      expect { DOI.new '12.'}.to raise_error DOI::Malformed
    end
  end

  context 'when it has a registrant' do
    it 'is well-formed' do
      expect { DOI.new '10.1234'}.not_to raise_error
    end
  end

  context 'when it does not have a registrant' do
    it 'is malformed' do
      expect { DOI.new '10.' }.to raise_error DOI::Malformed
    end
  end
end
