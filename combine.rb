require 'json'
require 'csv'
second_row = 1
journal_file = 2
journal_csv_doc = File.open ARGV[journal_file]
journal_csv_row = CSV.new(journal_csv_doc).read[second_row]
article_file = 3
article_csv_doc = File.open ARGV[article_file]
article_csv_row = CSV.new(article_csv_doc).read[second_row]
author_file = 4
author_json_doc = File.open ARGV[author_file]
author_json     = JSON.parse(author_json_doc.read)

doi = 0
title = 1
journal_title = 2
article_as_json = {
  "doi" => article_csv_row[doi],
  "title" => article_csv_row[title],
  "author" => author_json['name'],
  "journal"=> journal_csv_row[0],
  "issn" => article_csv_row[2]
}

puts JSON.pretty_generate article_as_json
