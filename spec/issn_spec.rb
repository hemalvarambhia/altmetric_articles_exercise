describe 'ISSNs' do
  class ISSN
    attr_reader :code
    Malformed = Class.new(Exception)
    
    def initialize(code)
      digits = code.scan(/\d/)
      raise Malformed.new unless digits.count == 8
      raise Malformed.new if code.scan(/[a-z]/i).any?
      @code = code
      @code = code.insert(4, '-') if code.scan(/-/).none?
    end
  end

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
end