require 'issn'
describe 'ISSN' do
  include ISSN

  describe 'correcting an ISSN code' do
    context 'when it is missing a dash in the middle' do
      it 'is added there' do
        expect(correct_issn('12345678')).to eq '1234-5678'
      end
    end

    context 'when the dash is already in the right place' do
      it 'does not add another dash' do
        expect(correct_issn('8765-4321')).to eq '8765-4321'
      end
    end
  end

  describe 'an ISSN' do
    module ISSN
      class ISSN
        Malformed = Class.new(Exception)
        def initialize(code)
          raise Malformed.new("ISSN '#{code}' is malformed") if code.empty?
        end
      end
    end

    context 'when it is blank' do
      it 'is malformed' do
        expect { ISSN::ISSN.new('') }.to raise_exception ISSN::ISSN::Malformed
      end
    end

    context 'when it consists of 8 numbers with a dash in the middle' do
      it 'is well-formed' do
        expect { ISSN::ISSN.new('1234-8694') }.not_to raise_exception
      end
    end
  end
end