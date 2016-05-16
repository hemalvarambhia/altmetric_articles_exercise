require 'csv'
require 'altmetric_file'
require 'article_csv_parser'
require 'articles_table'
require 'journal_csv_parser'
require 'journals_table'
require 'author_json_doc'
require 'author_json_parser'
require 'authors_table'
require 'combined'
require 'json_document'
require 'csv_document'
describe 'Combined' do
  describe '#output_to' do
    before(:each) do
      docs_dir = File.join(File.dirname(__FILE__), 'sample_docs')

      articles_csv = File.join(docs_dir, 'one_article.csv')
      articles_table = articles_table_from articles_csv

      journals_csv = File.join(docs_dir, 'one_journal.csv')
      journals_table = journals_table_from journals_csv

      authors_json = File.join(docs_dir, 'one_author.json')
      authors_table = authors_table_from authors_json

      @combiner = Combined.new(articles_table, journals_table, authors_table)
    end
    
    it 'publishes the merged data to a JSON document' do
      json_document = JSONDocument.new
        
      @combiner.output_to json_document
      
      expect(json_document.content).not_to be_empty
    end

    it 'publishes the merged data to a CSV document' do
      csv_document = CSVDocument.new
        
      @combiner.output_to csv_document
      
      expect(csv_document.content).not_to be_empty
    end

    def articles_table_from(path)
      article_csv_doc = CSV.new(File.open(path), {headers: true})
      altmetric_file = AltmetricFile.new(article_csv_doc, ArticleCSVParser)
      ArticlesTable.from altmetric_file
    end

    def journals_table_from(path)
      journal_csv = CSV.new(File.open(path), {headers: true})
      altmetric_file = AltmetricFile.new(journal_csv, JournalCSVParser)
      JournalsTable.from altmetric_file
    end

    def authors_table_from(path)
      authors_json_doc = AuthorJSONDoc.new(File.open(path))
      AuthorsTable.from AltmetricFile.new(authors_json_doc, AuthorJSONParser)
    end
  end
end
