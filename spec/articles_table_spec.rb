require 'issn'
require 'doi'
describe 'Articles Table' do
  class ArticlesTable
    def initialize(row)
      @row = row
    end

    def merge(journal_table, author_table = nil)
      @row.merge(
          {
              journal: journal_table.find(@row[:issn]),
              author: author_table.find(@row[:doi])
          }
      )
    end
  end

  describe '#merge' do
    it 'includes the DOI and ISSN' do
      issn = an_issn
      doi = a_doi
      authors_table = double(:authors_table).as_null_object
      journals_table = double(:journals_table).as_null_object
      articles_table = ArticlesTable.new({ issn: issn, doi: doi })
      expect(articles_table.merge(journals_table, authors_table)).to include(issn: issn, doi: doi)
    end

    describe 'merging with a journals table' do
      it 'includes the title of the journal in the row' do
        issn = an_issn
        authors_table = double(:authors_table).as_null_object
        journals_table = double(:journals_table)
        articles_table = ArticlesTable.new({ issn: issn })
        expect(journals_table).to receive(:find).with(issn).and_return 'Science'

        expect(articles_table.merge(journals_table, authors_table)).to include(journal: 'Science')
      end
    end

    describe 'merging with an authors table' do
      it 'includes the author in the row' do
        doi = a_doi
        authors_table = double(:authors_table)
        expect(authors_table).to receive(:find).with(doi).and_return 'Scientist'
        journals_table = double(:journals_table).as_null_object
        articles_table = ArticlesTable.new({ doi: doi })
        expect(articles_table.merge(journals_table, authors_table)).to(include(author: 'Scientist'))
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