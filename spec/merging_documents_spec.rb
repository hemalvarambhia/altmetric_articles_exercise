describe 'merging documents' do
  before :each do
    @article_csv_doc = double(:articles_csv)
    @journal_csv_doc = double(:journals_csv)
    @author_json_doc = double(:authors_json)
  end

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

  describe 'outputting the result to JSON' do
    before :each do
      @format = 'json'
    end

    it 'merges an article with its authors and the journal it was published in' do
      allow(@article_csv_doc).to(
          receive(:each).and_yield(
              { doi: '10.1234/altmetric0', title: 'About Physics', issn: '8456-2422' }
          ))
      allow(@author_json_doc).to(
          receive(:find).with('10.1234/altmetric0').and_return [ 'Author' ])
      allow(@journal_csv_doc).to receive(:find).with('8456-2422').and_return 'Nature'

      merged_row = merge(@article_csv_doc, @author_json_doc, @journal_csv_doc, @format)

      expected = {
          doi: '10.1234/altmetric0', title: 'About Physics', author: 'Author',
          journal: 'Nature', issn: '8456-2422'
      }
      expect(merged_row).to(include(expected))
    end

    it 'merges all articles with their authors and the journal it was published in' do
      rows = [
          {doi: '10.1234/altmetric1', title: 'About Chemistry', issn: '6844-2395'},
          {doi: '10.1234/altmetric2', title: 'About Biology', issn: '5679-2344'},
          {doi: '10.1234/altmetric3', title: 'About Biology', issn: '3141-5916'},
      ]
      allow(@article_csv_doc).to(
          receive(:each).and_yield(rows[0]).and_yield(rows[1]).and_yield(rows[2]))
      allow(@author_json_doc).to receive(:find).with(any_args).and_return an_author
      allow(@journal_csv_doc).to receive(:find).with(any_args).and_return a_journal

      merged_rows = merge(@article_csv_doc, @author_json_doc, @journal_csv_doc, @format)

      expect(merged_rows.size).to eq rows.size
    end
  end

  describe 'outputting the result to CSV' do
    before :each do
      @format = 'csv'
    end

    it 'merges the article with its author and the journal it was published' do
      allow(@article_csv_doc).to(
          receive(:each).and_yield(
              { doi: '10.1234/altmetric0', title: 'About Physics', issn: '8456-2422' }
          ))
      allow(@author_json_doc).to(
          receive(:find).with('10.1234/altmetric0').and_return [ 'Author' ])
      allow(@journal_csv_doc).to receive(:find).with('8456-2422').and_return 'Nature'

      merged_row = merge(@article_csv_doc, @author_json_doc, @journal_csv_doc, @format)

      expected = ['10.1234/altmetric0', 'About Physics', 'Author', 'Nature', '8456-2422']

      expect(merged_row).to(include(expected))
    end
  end

  def an_author
    ['Biologist', 'Chemist', 'Physicist', 'Engineer'].sample(1)
  end

  def a_journal
    ['J. Chem. Phys.', 'J. Bio.', 'J. Phys. B'].sample
  end
end