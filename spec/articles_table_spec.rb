require 'issn'
require 'doi'
describe 'Articles Table' do
  class ArticlesTable
    def self.from(file)
      new(file.read)
    end

    def initialize(row)
      @row = row
    end

    def join(journal_table, author_table)
      @row.merge(
          {
              journal: journal_table.find(@row[:issn]),
              authors: author_table.find(@row[:doi])
          }
      )
    end
  end

  describe '.from' do
    it 'loads the table from a file' do
      file = double(:article_csv_file)
      expect(file).to receive(:read)

      ArticlesTable.from file
    end
  end

  describe '#join' do
    it 'includes the DOI and ISSN' do
      row = {issn: an_issn, doi: a_doi}
      authors_table = double(:authors_table).as_null_object
      journals_table = double(:journals_table).as_null_object
      articles_table = ArticlesTable.new(row)

      expect(articles_table.join(journals_table, authors_table)).to include(row)
    end

    describe 'merging with a journals table' do
      it 'includes the title of the journal in the row' do
        row = {issn: an_issn}
        authors_table = double(:authors_table).as_null_object
        journals_table = double(:journals_table)
        articles_table = ArticlesTable.new(row)
        expect(journals_table).to receive(:find).with(row[:issn]).and_return 'Science'

        joined_table = articles_table.join(journals_table, authors_table)
        expect(joined_table).to include(journal: 'Science')
      end

      context 'when the journal does not exist' do
        it 'assigns a blank journal in the row' do
          row = {issn: an_issn}
          authors_table = double(:authors_table).as_null_object
          journals_table = double(:journals_table)
          articles_table = ArticlesTable.new(row)
          expect(journals_table).to receive(:find).with(row[:issn]).and_return nil

          joined_table = articles_table.join(journals_table, authors_table)
          expect(joined_table).to include(journal: nil)
        end
      end
    end

    describe 'merging with an authors table' do
      it 'includes the author in the row' do
        row = {doi: a_doi}
        authors_table = double(:authors_table)
        expect(authors_table).to receive(:find).with(row[:doi]).and_return ['Physicist']
        journals_table = double(:journals_table).as_null_object
        articles_table = ArticlesTable.new(row)

        joined_table = articles_table.join(journals_table, authors_table)
        expect(joined_table).to(include(authors: ['Physicist']))
      end

      context 'when the article has no authors' do
        it 'lists no authors in the row' do
          row = {doi: a_doi}
          authors_table = double(:authors_table)
          expect(authors_table).to receive(:find).with(row[:doi]).and_return []
          journals_table = double(:journals_table).as_null_object
          articles_table = ArticlesTable.new(row)

          joined_table = articles_table.join(journals_table, authors_table)
          expect(joined_table).to(include(authors: []))

        end
      end
    end
  end

  private

  def a_doi
    DOI.new('10.1234/altmetric001')
  end

  def an_issn
    ISSN.new('1234-9865')
  end
end
