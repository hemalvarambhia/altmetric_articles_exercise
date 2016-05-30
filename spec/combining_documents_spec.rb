require 'doi_helper'
require 'issn_helper'
describe 'combining articles, journals and authors documents' do
  include CreateDOI, CreateISSN
  class DocumentsCombined
    def initialize(article_csv_doc, journal_csv_doc, author_json_doc)
      @article_csv_doc = article_csv_doc
      @journal_csv_doc = journal_csv_doc
      @author_json_doc = author_json_doc
    end

    def read
      merged = []
      @article_csv_doc.each do |row|
        merged = [
        {
          doi: row[:doi],
          title: row[:title],
          issn: row[:issn],
          journal: @journal_csv_doc.find(row[:issn]),
          author: @author_json_doc.find(row[:doi])
        }]
      end

      merged
    end
  end
  
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
      @row = {
        doi: generate_doi,
        title: 'About Physics',
        issn: generate_issn
      }

     allow(@article_csv_doc).to receive(:each).and_yield(@row)
    end
    
    context 'when the journal and author(s) are present in the docs' do
      before :each do
        allow(@author_json_doc)
          .to receive(:find).with(@row[:doi]).and_return ['Author']
        allow(@journal_csv_doc)
          .to receive(:find).with(@row[:issn]).and_return 'Nature'
      end

      it 'merges the journal title and author in' do
        content = @documents_combined.read
        
        row = content.detect { |row| row[:doi] == @row[:doi] }
        merged_in = {journal: 'Nature', author:  ['Author' ]}
        expect(row).to include merged_in
      end
    end

    context 'when the journal and author are not in their docs' do
      before(:each) do
        no_authors = []
        allow(@author_json_doc)
          .to receive(:find).with(@row[:doi]).and_return no_authors
        no_such_journal = ''
        allow(@journal_csv_doc)
          .to receive(:find).with(@row[:issn]).and_return no_such_journal
      end
      
      it 'merges in a blank journal title and an empty author list' do
        content = @documents_combined.read
        
        row = content.detect { |row| row[:doi] == @row[:doi] }
        expect(row).to include(journal: '', author: [])
      end
    end
    
    describe 'merging all articles' do
      before(:each) do
        allow(@article_csv_doc).to(
          receive(:each).and_yield(a_row).and_yield(a_row).and_yield(a_row)
        )
        allow(@journal_csv_doc).to(
          receive(:find).with(any_args).and_return a_journal
        )
        allow(@author_json_doc).to(
          receive(:find).with(any_args).and_return authors
        )
      end
      
      it 'merges in their journal and author(s)' do
        rows = @documents_combined.read
        
        rows.each do |row|
          expect(row).to have_key(:journal).and have_key(:author)
        end
      end
      
      def a_row
        {
          doi: generate_doi, title: 'Science Article', issn: generate_issn
        }
      end

      def a_journal
        [
          'J. Phys. B',
          'J. Phys. Conf. Series',
          'Nature',
          'Phys. Rev. Lett.',
          ''
        ].sample
      end

      def authors
        some_authors = [
          'P A M Dirac', 'A Einstein', 'L Euler', 'E Schrodinger',
          'W Heisenberg'
        ]

        some_authors.sample(rand(0..some_authors.size))
      end
    end
  end
end
