require 'issn_helper'
describe 'The journal csv doc' do
  include CreateISSN

  class JournalCSVDoc
    def initialize(content = [])
       @journals = Hash[content.collect {|row| row.reverse}]
    end

    def find issn
      @journals[issn]
    end
  end

  describe '#find' do
    context 'when there is a title for the given issn' do
      before(:each) { @issn = generate_issn }

      it 'returns the title' do
        journal_csv_doc = JournalCSVDoc.new ([['Nature', @issn]])

        expect(journal_csv_doc.find(@issn)).to eq 'Nature'
      end

      it 'returns the title for any given ISSN' do
        journal_csv_doc = JournalCSVDoc.new ([['J. Phys. B', @issn]])

        expect(journal_csv_doc.find(@issn)).to eq 'J. Phys. B'
      end
    end
  end
end