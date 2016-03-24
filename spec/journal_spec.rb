require 'journal'

describe 'A Journal' do
  describe 'Equating two journals' do
    context 'when they have the same ISSN' do
     it 'marks them as being the same' do
        journal = Journal.new(nil, '5555-7777')
        journal_with_same_issn = Journal.new(nil, '5555-7777')
        expect(journal).to eq journal_with_same_issn
      end
    end

    context 'when they have different ISSNs' do
      it 'marks them as being different' do
        journal = Journal.new(nil, '1111-2222')
        with_different_issn = Journal.new(nil, '4444-6542')    

        expect(journal).not_to eq with_different_issn
      end
    end

    it 'is reflexive' do
      journal = Journal.new(nil, '6543-9875')      

      expect(journal).to eq journal
    end

    it 'is symmetric' do
      journal_1 = Journal.new(nil, '7956-4233')
      journal_2 = Journal.new(nil, '7956-4233')

      expect(journal_1).to eq journal_2
      expect(journal_2).to eq journal_1
    end

    it 'is transitive' do
      journal_1 = Journal.new(nil, '3141-5917')
      journal_2 = Journal.new(nil, '3141-5917')
      journal_3 = Journal.new(nil, '3141-5917')

      expect(journal_1).to eq journal_2
      expect(journal_2).to eq journal_3
      expect(journal_3).to eq journal_1
    end
  end
end