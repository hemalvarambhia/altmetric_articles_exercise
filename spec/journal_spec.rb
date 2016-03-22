describe 'A Journal' do
  class Journal
    attr_reader :title, :issn

    def initialize(title, issn)
      @title = title
      @issn = issn
    end

    def ==(other)
      true
    end
  end

  it 'stores its name' do
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
    it 'marks two journals with the same ISSNs as the same' do
      journal = Journal.new(nil, '5555-7777')
      journal_with_same_issn = Journal.new(nil, '5555-7777')
      expect(journal).to eq journal_with_same_issn
    end
  end
end