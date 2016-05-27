describe 'merging documents' do

  def merge(article_csv_doc, author_json_doc, journal_csv_doc, format)
    rows = []
    article_csv_doc.each do |article|
      rows << {
          doi: article[:doi],
          title: article[:title],
          author: author_json_doc.find(article[:doi]).join,
          journal: journal_csv_doc.find(article[:issn]),
          issn: article[:issn]
      }
    end

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
    row.values
  end

  before :each do
    @article_csv_doc = double(:articles_csv)
    @journal_csv_doc = double(:journals_csv)
    @author_json_doc = double(:authors_json)
  end

  describe 'merging an article with its author(s) and journal' do
    before :each do
      row = {
          doi: '10.1234/altmetric0',
          title: 'About Physics',
          issn: '8456-2422'
      }
      allow(@article_csv_doc).to(yield_rows(row))
      allow(@author_json_doc)
          .to receive(:find).with(row[:doi]).and_return ['Author']
      allow(@journal_csv_doc)
          .to receive(:find).with(row[:issn]).and_return 'Nature'
    end

    describe 'JSON format' do
      before :each do
        @format = 'json'
      end

      it 'includes the DOI, title and ISSN' do
        merged_row = merge_documents.first

        expected = {
            doi: '10.1234/altmetric0', title: 'About Physics',
            issn: '8456-2422'
        }
        expect(merged_row).to(include(expected))
      end

      it 'includes the author and journal title' do
        merged_row = merge_documents.first

        expected = { author: 'Author', journal: 'Nature' }
        expect(merged_row).to(include(expected))
      end
    end

    describe 'CSV format' do
      before :each do
        @format = 'csv'
      end

      it 'includes the DOI, title and ISSN' do
        merged_row = merge_documents.first

        expect(merged_row).to(have('10.1234/altmetric0').in_column(0))
        expect(merged_row).to(have('About Physics').in_column(1))
        expect(merged_row).to(have('8456-2422').last)
      end

      it 'includes the author and journal title' do
        merged_row = merge_documents.first

        expect(merged_row).to(have('Author').in_column(2))
        expect(merged_row).to(have('Nature').in_column(3))
      end
    end

    RSpec::Matchers.define :have do |expected|
      match do |actual|
       actual[@index] == expected
      end

      chain :in_column do |offset|
        @index = offset
      end

      chain :last do
        @index = -1
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

      merged_rows = merge_documents

      expect(merged_rows.size).to eq rows.size
    end
  end

  def merge_documents
    merge(@article_csv_doc, @author_json_doc, @journal_csv_doc, @format)
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