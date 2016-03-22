describe 'A Journal' do
  class Journal
    attr_reader :title, :issn

    def initialize(title, issn)
      @title = title
      @issn = issn
    end

    def ==(other)
      issn == other.issn
    end
  end

  it 'stores its title' do
    journal = Journal.new('Journal of Physics B', nil)

    expect(journal.title).to eq 'Journal of Physics B'
  end

  it 'stores any title passed to it' do
    journal = Journal.new('Chemical Physics Letters', nil)

    expect(journal.title).to eq 'Chemical Physics Letters'
  end

  it 'stores its ISSN' do
    journal = Journal.new(nil, '1234-5678')

    expect(journal.issn).to eq '1234-5678'
  end 

  it 'stores any ISSN' do
    journal = Journal.new(nil, '2468-1012')

    expect(journal.issn).to eq '2468-1012'
  end

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