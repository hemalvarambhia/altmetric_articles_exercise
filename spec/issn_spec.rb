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
        attr_reader :code

        Malformed = Class.new(Exception)
        def initialize(code)
          raise Malformed.new("ISSN '#{code}' is malformed") unless code=~/^\d{4}-?\d{4}$/
          @code = code
          @code = code.insert(4, '-') if dash_missing?(code)
        end

        def dash_missing?(code)
          code.scan(/-/).none?
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

    context "when it consists of more than 8 numbers with a '-' in the middle" do
      it 'is malformed' do
        expect { ISSN::ISSN.new('4586434-93546584') }
            .to raise_exception ISSN::ISSN::Malformed
      end
    end

    context 'when it contains any letter characters' do
      it 'is malformed' do
        expect { ISSN::ISSN.new('9b4c8s2-954a2') }
            .to raise_exception ISSN::ISSN::Malformed
        expect { ISSN::ISSN.new('1A2B3C4D-6T7D89') }
            .to raise_exception ISSN::ISSN::Malformed
      end
    end

    context "when the '-' is not in the middle" do
      it 'is malformed' do
        expect { ISSN::ISSN.new('12-346789') }.to raise_exception ISSN::ISSN::Malformed
      end
    end

    context "when there is anything but a '-' in the middle" do
      it 'is malformed' do
        expect { ISSN::ISSN.new('1234/6789') }.to raise_exception ISSN::ISSN::Malformed
      end
    end

    it 'stores the code' do
      expect(ISSN::ISSN.new('6849-2347').code).to eq '6849-2347'
    end

    context "when the dash is missing" do
      it 'is still well-formed' do
        expect { ISSN::ISSN.new('76540442') }.not_to raise_exception
      end

      it 'adds the dash in the correct place' do
        expect( ISSN::ISSN.new('86756657').code).to eq '8675-6657'
      end
    end
  end
end