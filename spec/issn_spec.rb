require 'issn'
describe 'ISSNs' do
  context 'when blank' do
    it 'is malformed' do
      expect{ ISSN.new('') }.to raise_error ISSN::Malformed 
    end
  end

  context "when it consists of just 8 numbers with a '-' in the middle" do
    it 'is well formed' do
      expect{ ISSN.new('1234-5678') }.not_to raise_error
    end

    it 'stores the code' do
      expect(ISSN.new('1234-5678').code).to eq '1234-5678'
    end
  end

  context 'when it consists of just 8 numbers and no dash' do
    it 'is well formed' do
      expect{ ISSN.new ('34567890') }.not_to raise_error
    end

    it 'adds a dash in the middle' do
      expect(ISSN.new('78904321').code).to eq '7890-4321'
    end
  end

  context 'when it contains any letters' do
    it 'is malformed' do
      expect{ ISSN.new('1f2v34-76a5a4') }.to raise_error ISSN::Malformed
      expect{ ISSN.new('1F5H45-T6754') }.to raise_error ISSN::Malformed
    end
  end

  context "when it contains any non-word character other than '-'" do
    it 'is malformed' do
      expect{ ISSN.new('5643-/1111') }.to raise_error ISSN::Malformed
    end
  end

  describe '#==' do
    context 'when the ISSNs are different' do
      it 'marks them as being unequal' do
        issn = ISSN.new '4325-8760'
        different_issn = ISSN.new '3289-4444'

        expect(issn).not_to eq different_issn
      end
    end

    context 'when the ISSN codes are the same' do
      it 'marks them as being the same' do
        issn = ISSN.new '5190-7189'
        with_same_code = ISSN.new '5190-7189'

        expect(issn).to eq with_same_code
      end
    end

    it 'is reflexive' do
      issn = ISSN.new '8768-6453'

      expect(issn).to eq issn
    end

    it 'is symmetric' do
      issn_1 = ISSN.new '1324-1983'
      issn_2 = ISSN.new '1324-1983'   

      expect(issn_1).to eq issn_2
      expect(issn_2).to eq issn_1
    end

    it 'is transitive' do
      issn_1 = ISSN.new '1486-2016'
      issn_2 = ISSN.new '1486-2016'
      issn_3 = ISSN.new '1486-2016'

      expect(issn_1).to eq issn_2
      expect(issn_2).to eq issn_3
      expect(issn_1).to eq issn_3
    end
  end
end
