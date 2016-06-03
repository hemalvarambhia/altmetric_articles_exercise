$LOAD_PATH.unshift 'lib'
require 'csv'
require 'json'
require 'optparse'
require 'in_format'
require 'documents_combined'
require 'article_csv_doc'
require 'journal_csv_doc'
require 'author_json_doc'
options = {}

OptionParser.new do |opts|
  opts.banner = "Usage: combine.rb [options]"

  opts.on("-f", "--format FORMAT", String, "Render articles to a particular format") do |format|
    options[:format] = format
  end
end.parse!

format = options[:format]
journal_csv, articles_csv, authors_json = [ARGV[0], ARGV[1], ARGV[2]]

journal_csv_doc = JournalCSVDoc.new(
    CSV.new(File.open(journal_csv), headers:true, :header_converters => :symbol)
)
articles_csv_doc = ArticleCSVDoc.new(
    CSV.new(File.open(articles_csv), headers:true, :header_converters => :symbol)
)
author_json_doc = AuthorJSONDoc.new(
    JSON.parse(File.open(authors_json).read)
)
documents_combined = DocumentsCombined.new(
    articles_csv_doc,
    journal_csv_doc,
    author_json_doc)

format = InFormat.output(format, documents_combined)
puts format
