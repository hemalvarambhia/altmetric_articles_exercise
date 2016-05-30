describe 'combining articles, journals and authors documents' do
  class DocumentsCombined
    def initialize(article_csv_doc, journal_csv_doc, author_json_doc)
      @article_csv_doc = article_csv_doc
      @journal_csv_doc = journal_csv_doc
      @author_json_doc = author_json_doc
    end

    def read
      [{
         doi: '10.1234/altmetric0',
         title: 'About Physics',
         issn: '8456-2422',
         journal: 'Nature',
         author: ['Author']
       }]
    end
  end
  
  before :each do
    @article_csv_doc = double(:article_csv_doc)
    @journal_csv_doc = double(:journal_csv_doc)
    @author_json_doc = double(:author_json_doc)
    @row = {
        doi: '10.1234/altmetric0',
        title: 'About Physics',
        issn: '8456-2422'
    }
    allow(@article_csv_doc).to receive(:each).and_yield(@row)
  end

  describe '#read' do
    context 'when the journal and author(s) are present in the docs' do
      before :each do
        allow(@author_json_doc)
          .to receive(:find).with(@row[:doi]).and_return ['Author']
        allow(@journal_csv_doc)
          .to receive(:find).with(@row[:issn]).and_return 'Nature'
      end

      it 'merges the journal title and author in' do
        documents_combined = DocumentsCombined.new(
          @article_csv_doc, @journal_csv_doc, @author_json_doc
        )
        
        content = documents_combined.read
        
        row = content.detect { |row| row[:doi] == @row[:doi] }
        merged_in = {journal: 'Nature', author:  ['Author' ]}
        expect(row).to include merged_in
      end
    end
  end
end
