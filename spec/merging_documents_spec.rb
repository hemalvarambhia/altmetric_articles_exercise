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

    return rows.collect { |row| as_json row } if format == 'json'
    return rows.collect { |row| as_csv row } if format == 'csv'
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
      row = {doi: '10.1234/altmetric0', title: 'About Physics', issn: '8456-2422'}
      allow(@article_csv_doc).to(yield_rows(row))
      allow(@author_json_doc).to(
          receive(:find).with('10.1234/altmetric0').and_return [ 'Author' ])
      allow(@journal_csv_doc).to receive(:find).with('8456-2422').and_return 'Nature'
    end

    describe 'JSON format' do
      before :each do
        @format = 'json'
      end

      it 'contains the DOI, title, author, journal title and ISSN' do
        merged_row = merge_documents

        expected = {
            doi: '10.1234/altmetric0', title: 'About Physics', author: 'Author',
            journal: 'Nature', issn: '8456-2422'
        }
        expect(merged_row).to(include(expected))
      end
    end

    describe 'CSV format' do
      before :each do
        @format = 'csv'
      end

      it 'contains the DOI, title, author, journal title and ISSN' do
        merged_row = merge_documents

        expected = ['10.1234/altmetric0', 'About Physics', 'Author', 'Nature', '8456-2422']
        expect(merged_row).to(include(expected))
      end
    end
  end

  describe 'merging multiple articles' do
    before :each do
      @format = 'json'
    end

    it 'renders all the rows contained the article CSV document' do
      rows = [
          {doi: '10.1234/altmetric1', title: 'About Chemistry', issn: '6844-2395'},
          {doi: '10.1234/altmetric2', title: 'About Biology', issn: '5679-2344'},
          {doi: '10.1234/altmetric3', title: 'About Biology', issn: '3141-5916'},
      ]
      allow(@article_csv_doc).to(yield_rows(*rows))
      allow(@author_json_doc).to receive(:find).with(any_args).and_return an_author
      allow(@journal_csv_doc).to receive(:find).with(any_args).and_return a_journal

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
end