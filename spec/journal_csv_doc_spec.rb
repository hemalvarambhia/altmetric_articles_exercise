require 'support/create_issn'
require 'journal_csv_doc'
describe 'The journal csv doc' do
  include CreateISSN
  it 'is empty by default' do
    journal_csv_doc = JournalCSVDoc.new

    expect(journal_csv_doc).to be_empty
  end

  describe '#find' do
    before(:each) { @issn = generate_issn }

    context 'when there is a title for the given issn' do
      it 'returns the title' do
        journal_csv_doc = given_a_journal_csv_doc_with(
            journals_including(title: 'Phys. Rev. A', issn: @issn))

        expect(journal_csv_doc.find(to_issn(@issn))).to eq 'Phys. Rev. A'
      end

      it 'returns the title for any given ISSN' do
        journal_csv_doc = given_a_journal_csv_doc_with(
            journals_including(title: 'Chem. Phys Lett.', issn: @issn))

        expect(journal_csv_doc.find(to_issn(@issn))).to eq 'Chem. Phys Lett.'
      end
    end

    context 'when there is no title for the given ISSN' do
      it 'returns no title' do
        journal_csv_doc = given_a_journal_csv_doc_with(some_journals)

        expect(journal_csv_doc.find(to_issn(@issn))).to eq ''
      end
    end
  end

  def given_a_journal_csv_doc_with(journals)
    JournalCSVDoc.new(journals)
  end

  def journals_including(journal)
    some_journals + [ journal ]
  end

  def some_journals
    Array.new(3) { {title: a_journal, issn: generate_issn} }
  end

  def a_journal
    [
        'J. Phys. B',
        'J. Phys. Conf. Series',
        'Nature',
        'Phys. Rev. Lett.',
    ].sample
  end

  def to_issn(issn)
    ISSN.new issn
  end
end