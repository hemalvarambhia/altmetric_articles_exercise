require 'ostruct'
require 'support/create_doi'
require 'support/create_issn'
require 'support/create_author'
require 'support/journal_helper'
require 'documents_combined'
describe 'combining articles, journals and authors documents' do
  include CreateAuthor, JournalHelper, CreateDOI, CreateISSN

  before :each do
    @article_csv_doc = double(:article_csv_doc)
    @journal_csv_doc = double(:journal_csv_doc)
    @author_json_doc = double(:author_json_doc)
    @documents_combined = DocumentsCombined.new(
      @article_csv_doc, @journal_csv_doc, @author_json_doc
    )
  end

  describe '#read' do
    before :each do
      @article = an_article
      allow(@article_csv_doc).to receive(:read).and_return([ @article ])
    end
    
    context 'when the journal and author(s) are present in the docs' do
      before :each do
        @author = ['Author']
        allow(@author_json_doc)
          .to receive(:find).with(@article[:doi]).and_return @author
        @journal = 'Nature'
        allow(@journal_csv_doc)
            .to receive(:find).with(@article[:issn]).and_return @journal
      end

      it 'merges the journal title and author in' do
        content = @documents_combined.read

        row = content.detect { |row| row[:doi] == @article[:doi] }
        merged_in = {journal: @journal, author: @author}
        expect(row).to include merged_in
      end
    end

    context 'when the journal and author are not in their docs' do
      before(:each) do
        @no_authors = []
        allow(@author_json_doc)
          .to receive(:find).with(@article[:doi])
                  .and_return CreateAuthor::NO_AUTHORS
        @no_such_journal = ''
        allow(@journal_csv_doc)
          .to receive(:find).with(@article[:issn])
                  .and_return JournalHelper::NO_SUCH_JOURNAL
      end
      
      it 'merges in a blank journal title and an empty author list' do
        content = @documents_combined.read
        
        row = content.detect { |row| row[:doi] == @article[:doi] }
        merged_in = {
            journal: JournalHelper::NO_SUCH_JOURNAL,
            author: CreateAuthor::NO_AUTHORS
        }
        expect(row).to include(merged_in)
      end
    end
    
    describe 'merging all articles' do
      before(:each) do
        @articles = Array.new(3) { an_article }
        allow(@article_csv_doc).to receive(:read).and_return @articles
        allow(@journal_csv_doc).to(
          receive(:find).with(any_args).and_return a_journal
        )
        allow(@author_json_doc).to(
          receive(:find).with(any_args).and_return authors
        )
      end
      
      it 'merges in their journal and author(s)' do
        rows = @documents_combined.read

        expect(rows.size).to eq(@articles.size)
        rows.each do |row|
          expect(row).to have_key(:journal).and have_key(:author)
        end
      end

      def a_journal
        [
          'J. Phys. B',
          'J. Phys. Conf. Series',
          'Nature',
          'Phys. Rev. Lett.',
          JournalHelper::NO_SUCH_JOURNAL
        ].sample
      end
    end

    def an_article
      OpenStruct.new(
        doi: DOI.new(generate_doi), title: 'Science Article', issn: ISSN.new(generate_issn)
      )
    end
  end
end
