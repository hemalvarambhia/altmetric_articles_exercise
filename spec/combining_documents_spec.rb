describe 'combining articles, journals and authors documents' do

  class DocumentCombiner
    def initialize(params)
      @article_csv_doc = params[:article_csv_doc]
      @journal_csv_doc = params[:journal_csv_doc]
      @author_json_doc = params[:author_json_doc]
    end

    #REFACTOR - the merge method has two responsibilities - merging and rendering
    def combine format
      merged_rows = []
      @article_csv_doc.each do |article|
        merged_rows << {
            doi: article[:doi],
            title: article[:title],
            author: @author_json_doc.find(article[:doi]).join,
            journal: @journal_csv_doc.find(article[:issn]),
            issn: article[:issn]
        }
      end

      output_in format, merged_rows
    end

    private

    def output_in format, rows
      renderer = case format
                   when 'json'
                     lambda { |row| as_json row }
                   when 'csv'
                     lambda { |row| as_csv row }
                 end

      rows.collect &renderer
    end

    def as_json(row)
      row
    end

    def as_csv(row)
      row.values_at(:doi, :title, :author, :journal, :issn)
    end
  end

  before :each do
    @article_csv_doc = double(:articles_csv)
    @journal_csv_doc = double(:journals_csv)
    @author_json_doc = double(:authors_json)
    @row = {
        doi: '10.1234/altmetric0',
        title: 'About Physics',
        issn: '8456-2422'
    }
    allow(@article_csv_doc).to(yield_rows(@row))
  end

  context 'when the journal and author(s) are present in the docs' do
    before :each do
      allow(@author_json_doc)
          .to receive(:find).with(@row[:doi]).and_return ['Author']
      allow(@journal_csv_doc)
          .to receive(:find).with(@row[:issn]).and_return 'Nature'
    end

    describe 'JSON formatted output' do
      before :each do
        @format = 'json'
      end

      it 'includes the DOI, title and ISSN' do
        merged_row = combine_documents.first

        expected = @row.values_at(:doi, :title, :issn)
        expect(merged_row.values_at(:doi, :title, :issn)).to eq expected
      end

      it 'includes the author and journal title' do
        merged_row = combine_documents.first

        expect(merged_row[:author]).to eq 'Author'
        expect(merged_row[:journal]).to eq 'Nature'
      end
    end

    describe 'CSV formatted output' do
      before :each do
        @format = 'csv'
      end

      it 'includes the DOI, title and ISSN' do
        merged_row = combine_documents.first

        expect(merged_row).to(have('10.1234/altmetric0').in_column(0))
        expect(merged_row).to(have('About Physics').in_column(1))
        expect(merged_row).to(have('8456-2422').last)
      end

      it 'includes the author and journal title' do
        merged_row = combine_documents.first

        expect(merged_row)
            .to have('Author').in_column(2).and(have('Nature').in_column(3))
      end

      RSpec::Matchers.define :have do |expected_field|
        match do |csv_row|
          csv_row[@index] == expected_field
        end

        chain :in_column do |offset|
          @index = offset
        end

        chain :last do
          @index = -1
        end

        failure_message do |csv_row|
          "Expected #{csv_row.inspect} to have #{expected_field} at position #{@index}"
        end
      end
    end
  end

  context 'when the journal or authors(s) are not present in the docs' do
    before :each do
      no_author = []
      allow(@author_json_doc)
          .to receive(:find).with(@row[:doi]).and_return no_author
      no_such_journal = ''
      allow(@journal_csv_doc)
          .to receive(:find).with(@row[:issn]).and_return no_such_journal
    end

    describe 'JSON format' do
      before :each do
        @format = 'json'
      end

      it 'present a blank author and journal title' do
        merged_row = combine_documents.first

        expect(merged_row[:journal]).to be_empty
        expect(merged_row[:author]).to be_empty
      end
    end
  end

  describe 'merging multiple articles' do
    before :each do
      @format = 'json'
    end

    it 'renders all the rows contained the article CSV document' do
      rows = Array.new(3) {{ doi: a_doi, title: 'Title', issn: an_issn }}

      allow(@article_csv_doc).to(yield_rows(*rows))
      allow(@author_json_doc)
          .to receive(:find).with(any_args).and_return an_author
      allow(@journal_csv_doc)
          .to receive(:find).with(any_args).and_return a_journal

      merged_rows = combine_documents

      expect(merged_rows.size).to eq rows.size
    end
  end

  def combine_documents
    DocumentCombiner.new(
        article_csv_doc: @article_csv_doc,
        journal_csv_doc: @journal_csv_doc,
        author_json_doc: @author_json_doc,
    ).combine @format
  end

  def yield_rows(*rows)
    each = receive(:each)
    rows.each { |row| each.and_yield row }

    each
  end

  def an_author
    ['Biologist', 'Chemist', 'Physicist', 'Engineer'].sample(1)
  end

  def a_journal
    ['J. Chem. Phys.', 'J. Bio.', 'J. Phys. B'].sample
  end

  def a_doi
    registrant = Array.new(4) { rand(0..9) }.join
    "10.#{registrant}/altmetric#{rand(100000000)}"
  end

  def an_issn
    code = Array.new(8) { rand(0..9) }
    "#{code.join}"
  end
end