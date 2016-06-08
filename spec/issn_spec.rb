require 'issn'
describe 'ISSN' do
  describe 'an ISSN' do
    context 'when it is blank' do
      it 'is malformed' do
        expect { issn('') }.to raise_exception ISSN::ISSN::Malformed
      end
    end

    context 'when it consists of 8 numbers with a dash in the middle' do
      it 'is well-formed' do
        expect { issn('1234-8694') }.not_to raise_exception
      end
    end

    context "when it consists of more than 8 numbers with a '-' in the middle" do
      it 'is malformed' do
        expect { issn('4586434-93546584') }
            .to raise_exception ISSN::ISSN::Malformed
      end
    end

    context 'when it contains any letter characters' do
      it 'is malformed' do
        expect { issn('9b4c8s2-954a2') }
            .to raise_exception ISSN::ISSN::Malformed
        expect { issn('1A2B3C4D-6T7D89') }
            .to raise_exception ISSN::ISSN::Malformed
      end
    end

    context "when the '-' is not in the middle" do
      it 'is malformed' do
        expect { issn('12-346789') }.to raise_exception ISSN::ISSN::Malformed
      end
    end

    context "when there is anything but a '-' in the middle" do
      it 'is malformed' do
        expect { issn('1234/6789') }.to raise_exception ISSN::ISSN::Malformed
      end
    end

    it 'stores the code' do
      expect(issn('6849-2347').code).to eq '6849-2347'
    end

    context "when the dash is missing" do
      it 'is still well-formed' do
        expect { issn('76540442') }.not_to raise_exception
      end

      it 'adds the dash in the correct place' do
        code = '86756657'
        expect( issn(code).code).to eq '8675-6657'
      end
    end

    describe '#==' do
      it 'is reflexive' do
        issn_1 = issn('5834-4239')

        expect(issn_1).to eq issn_1
      end

      it 'is symmetric' do
        issn_1 = issn('9355-1983')
        issn_2 = issn('9355-1983')

        expect(issn_1).to eq issn_2
      end

      it 'is transitive' do
        issn_1 = issn('5094-1944')
        issn_2 = issn('5094-1944')
        issn_3 = issn('5094-1944')

        expect(issn_1).to eq issn_2
        expect(issn_2).to eq issn_3
        expect(issn_3).to eq issn_1
      end

      context 'when the class of the object is different' do
        it 'confirms them as being unequal' do
          expect(issn('5834-3956')).not_to eq({})
        end
      end

      it 'confirms that a String with the same value is equal' do
        expect(issn('5968-4879')).to eq '5968-4879'
      end
    end

    describe '#hash' do
      it 'takes the value of the underlying code' do
        expect(issn('1230-2384').hash).to eq '1230-2384'.hash
      end
    end

    describe '#eql?' do
      it 'marks two ISSN with the same code as equal' do
        issn_1 = issn('5633-2222')
        issn_2 = issn('5633-2222')

        expect(issn_1.eql?(issn_2)).to be_truthy
      end
    end

    describe '#to_s' do
      it 'returns the underlying code' do
        expect(issn('9685-2480').to_s).to eq '9685-2480'
      end
    end

    def issn(code)
      ISSN::ISSN.new(code)
    end
  end
end