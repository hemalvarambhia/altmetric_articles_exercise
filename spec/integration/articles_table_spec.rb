require 'csv'
require 'altmetric_file'
require 'article_csv_parser'
require 'articles_table'
require 'journal_csv_parser'
require 'journals_table'
require 'author_json_doc'
require 'author_json_parser'
require 'authors_table'
describe 'ArticlesTable' do
  describe '#join' do
    it 'merges the author and journal of the article together' do
      expect(articles_table.join(journals_table, authors_table)).to(
        eq( { 
          doi: DOI.new('10.1234/altmetric0'), 
          title: 'Small Wooden Chair',
          issn: ISSN.new('1337-8688'),
          journal: 'Bartell-Collins',
          authors: ['Author 1']
        })
      ) 
    end

    def articles_table
      path_to_csv_doc = File.join(
        File.dirname(__FILE__),'sample_docs','one_article.csv')
      article_csv_doc = CSV.new(File.open(path_to_csv_doc), {headers: true})
      altmetric_file = AltmetricFile.new(article_csv_doc, ArticleCSVParser)
      ArticlesTable.from altmetric_file
    end

    def journals_table
      path_to_journal_csv = File.join(
        File.dirname(__FILE__), 'sample_docs', 'one_journal.csv'
      )
      journal_csv = CSV.new(File.open(path_to_journal_csv), {headers: true})
      altmetric_file = AltmetricFile.new(journal_csv, JournalCSVParser)
      JournalsTable.from altmetric_file
    end

    def authors_table
      path_to_json_doc = File.join(
        File.dirname(__FILE__), 'sample_docs', 'one_author.json'
      )
      authors_json_doc = AuthorJSONDoc.new(File.open(path_to_json_doc))
      AuthorsTable.from AltmetricFile.new(authors_json_doc, AuthorJSONParser)
    end
  end
end