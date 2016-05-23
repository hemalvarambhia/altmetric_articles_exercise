$LOAD_PATH.unshift 'lib'
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
require 'optparse'

options = {}

OptionParser.new do |opts|
  opts.banner = "Usage: combine.rb [options]"

  opts.on("-f", "--format FORMAT", String, "Render articles to a particular format") do |format|
    options[:format] = format
  end
end.parse!

format = options[:format]
journal_csv, articles_csv, authors_json = [ARGV[0], ARGV[1], ARGV[2]]

journals_csv_doc = AltmetricFile.new(
    CSV.new(File.open(journal_csv), {headers: true}),
    JournalCSVParser
)
journals = JournalsTable.from(journals_csv_doc)

authors_json_doc = AuthorJSONDoc.new(File.open(authors_json))
authors = AuthorsTable.from(
  AltmetricFile.new(authors_json_doc, AuthorJSONParser))

articles_csv_doc = AltmetricFile.new(
    CSV.new(File.open(articles_csv), {headers: true}),
    ArticleCSVParser)
articles = ArticlesTable.from(articles_csv_doc)

document = if format == 'json'
             JSONDocument.new
           else
             CSVDocument.new
           end

combined = Combined.new(articles, journals, authors)
combined.output_to document

puts document