require 'issn_helper'
require 'forwardable'
require 'journal_csv_doc'
describe 'The journal csv doc' do
  include CreateISSN, ISSN
  it 'is empty by default' do
    journal_csv_doc = JournalCSVDoc.new

    expect(journal_csv_doc).to be_empty
  end

  describe '#find' do
    before(:each) { @issn = generate_issn }

    context 'when there is a title for the given issn' do
      it 'returns the title' do
        journal_csv_doc = given_a_journal_csv_doc_with(
            some_content_including(title: 'Phys. Rev. A', issn: @issn))

        expect(journal_csv_doc.find(to_issn(@issn))).to eq 'Phys. Rev. A'
      end

      it 'returns the title for any given ISSN' do
        journal_csv_doc = given_a_journal_csv_doc_with(
            some_content_including(title: 'Chem. Phys Lett.', issn: @issn))

        expect(journal_csv_doc.find(to_issn(@issn))).to eq 'Chem. Phys Lett.'
      end
    end

    context 'when there is no title for the given ISSN' do
      it 'returns no title' do
        journal_csv_doc = given_a_journal_csv_doc_with(some_content)

        expect(journal_csv_doc.find(to_issn(@issn))).to eq ''
      end
    end
  end

  def given_a_journal_csv_doc_with(content)
    JournalCSVDoc.new(content)
  end

  def some_content_including(row)
    some_content + [ row ]
  end

  def some_content
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
end