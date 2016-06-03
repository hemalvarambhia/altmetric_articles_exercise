require 'issn_helper'
require 'issn'
require 'forwardable'
describe 'The journal csv doc' do
  include CreateISSN

  class JournalCSVDoc
    extend Forwardable
    include ISSN
    def_delegator :@journals, :empty?

    def initialize(content = [])
       @journals = Hash[
           content.collect { |title, issn| [correct_issn(issn), title] }
       ]
    end

    def find issn
      @journals.fetch(issn, '')
    end

    def has_issn?(issn)
      @journals.has_key? issn
    end
  end

  it 'is empty by default' do
    journal_csv_doc = JournalCSVDoc.new

    expect(journal_csv_doc).to be_empty
  end

  describe '#find' do
    before(:each) { @issn = generate_issn }

    context 'when there is a title for the given issn' do
      it 'returns the title' do
        journal_csv_doc = given_a_journal_csv_doc_with(
            some_content_including ['Phys. Rev. A', @issn])

        expect(journal_csv_doc.find(@issn)).to eq 'Phys. Rev. A'
      end

      it 'returns the title for any given ISSN' do
        journal_csv_doc = given_a_journal_csv_doc_with(
            some_content_including ['Chem. Phys Lett.', @issn])

        expect(journal_csv_doc.find(@issn)).to eq 'Chem. Phys Lett.'
      end
    end

    context 'when there is no title for the given ISSN' do
      it 'returns no title' do
        journal_csv_doc = given_a_journal_csv_doc_with(some_content)

        expect(journal_csv_doc.find(@issn)).to eq ''
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
    Array.new(3) { [a_journal, generate_issn] }
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