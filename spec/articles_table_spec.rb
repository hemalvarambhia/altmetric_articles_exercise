require 'articles_table'
require 'issn_helper'
require 'doi_helper'
describe 'Articles Table' do
  include CreateDOI, CreateISSN

  describe '#join' do
    it 'includes the DOI and ISSN' do
      row = {issn: an_issn, doi: a_doi}
      authors_table = double(:authors_table).as_null_object
      journals_table = double(:journals_table).as_null_object
      articles_table = ArticlesTable.new([row])

      joined_table = articles_table.join(journals_table, authors_table).first

      expect(joined_table).to include(row)
    end

    describe 'merging with a journals table' do
      before(:each) do
        @row = {issn: an_issn}
        @authors_table = double(:authors_table).as_null_object
        @journals_table = double(:journals_table)
        @articles_table = ArticlesTable.new([@row])
      end
      
      it 'includes the title of the journal in the row' do
        expect(@journals_table).to(
          receive(:find).with(@row[:issn]).and_return('Science'))

        joined_table =
          @articles_table.join(@journals_table, @authors_table).first

        expect(joined_table).to include(journal: 'Science')
      end

      context 'when the journal does not exist' do
        it 'assigns a blank journal in the row' do
          no_such_journal = nil
          expect(@journals_table).to(
            receive(:find).with(@row[:issn]).and_return no_such_journal)

          joined_table =
            @articles_table.join(@journals_table, @authors_table).first

          expect(joined_table).to include(journal: no_such_journal)
        end
      end
    end

    describe 'merging with an authors table' do
      before(:each) do
        @row = {doi: a_doi}
        @authors_table = double(:authors_table)
        @journals_table = double(:journals_table).as_null_object
        @articles_table = ArticlesTable.new([@row])
      end
      
      it 'includes the author in the row' do
        expect(@authors_table).to(
          receive(:find).with(@row[:doi]).and_return ['Physicist'])
 
        joined_table =
          @articles_table.join(@journals_table, @authors_table).first

        expect(joined_table).to(include(author: ['Physicist']))
      end

      context 'when the article has no authors' do
        it 'lists no authors in the row' do
          no_authors = []
          expect(@authors_table).to(
            receive(:find).with(@row[:doi]).and_return no_authors)

          joined_table =
            @articles_table.join(@journals_table, @authors_table).first
          expect(joined_table).to include(author: no_authors)
        end
      end
    end
  end

  describe '.from' do
    it 'loads the table from a file' do
      csv_rows = []
      file = double(:article_csv_file)
      expect(file).to receive(:read).and_return csv_rows

      ArticlesTable.from file
    end
  end

  describe 'articles with duplicate DOIs' do
    it 'only retains the first one with that DOI' do
      duplicated = a_doi
      row = { issn: an_issn, doi: duplicated }
      duplicate = { issn: an_issn, doi: duplicated }
      triplicate = { issn: an_issn, doi: duplicated }

      articles_table = ArticlesTable.new([row, duplicate, triplicate])

      expect(articles_table).to include row
      expect(articles_table).not_to include duplicate, triplicate
    end
  end
end
