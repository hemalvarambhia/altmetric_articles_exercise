require 'issn_helper'
describe 'The journal csv doc' do
  include CreateISSN

  class JournalCSVDoc
    def initialize(content = [])
       @journals = Hash[content.collect {|row| row.reverse}]
    end

    def find issn
      @journals.fetch(issn, '')
    end
  end

  describe '#find' do
    before(:each) { @issn = generate_issn }

    context 'when there is a title for the given issn' do
      it 'returns the title' do
        content = [
            ['Nature', @issn],
            [a_journal, generate_issn],
            [a_journal, generate_issn]
        ]
        journal_csv_doc = JournalCSVDoc.new (content)

        expect(journal_csv_doc.find(@issn)).to eq 'Nature'
      end

      it 'returns the title for any given ISSN' do
        content = [
            ['J. Phys. B', @issn],
            [a_journal, generate_issn],
            [a_journal, generate_issn]
        ]
        journal_csv_doc = JournalCSVDoc.new (content)

        expect(journal_csv_doc.find(@issn)).to eq 'J. Phys. B'
      end
    end

    context 'when there is no title for the given ISSN' do
      it 'returns no title' do
        content = [
            [a_journal, generate_issn],
            [a_journal, generate_issn],
            [a_journal, generate_issn]
        ]
        journal_csv_doc = JournalCSVDoc.new (content)

        expect(journal_csv_doc.find(@issn)).to eq ''
      end
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
end