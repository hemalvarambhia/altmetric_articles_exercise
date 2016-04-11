require 'doi'
describe 'DOIs' do
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

  context 'when it does not have an object ID' do
    it 'is malformed' do
      expect { DOI.new '10.1254/'}.to raise_error DOI::Malformed
    end
  end

  context 'when it does have an object ID' do
    it 'is well-formed' do
      expect { DOI.new '10.5943/altmetric1983' }.not_to raise_error
    end
  end

  describe '#equals' do
    it 'is reflexive' do
      doi = DOI.new '10.4520/altmetric888'
    
      expect(doi).to eq doi
    end
    
    it 'is symmetric' do
      doi = DOI.new '10.5699/altmetric6593'
      same_doi = DOI.new '10.5699/altmetric6593'

      expect(doi).to eq same_doi
      expect(same_doi).to eq doi
    end
  end
end
