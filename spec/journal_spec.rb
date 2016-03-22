describe 'A Journal' do
  class Journal
    attr_reader :title

    def initialize(title)
      @title = title
    end

    def title
      @title
    end

    def issn
      '1234-5678'
    end
  end

  it 'stores its name' do
    journal = Journal.new('Journal of Physics B')

    expect(journal.title).to eq 'Journal of Physics B'
  end

  it 'stores any title passed to it' do
    journal = Journal.new('Chemical Physics Letters')

    expect(journal.title).to eq 'Chemical Physics Letters'
  end

  it 'stores its ISSN' do
    journal = Journal.new(nil)

    expect(journal.issn).to eq '1234-5678'
  end 
end