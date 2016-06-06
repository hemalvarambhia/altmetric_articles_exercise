require 'csv'
require 'in_format'
require 'documents_combined'
require 'article_csv_doc'
require 'journal_csv_doc'
require 'author_json_doc'
describe 'Outputting combined documents' do
  before :each do
    @file_fixtures = File.join(File.dirname(__FILE__), 'file_fixtures')
    @a_format = ['csv', 'json'].sample
    @article_csv_doc = ArticleCSVDoc.new(
        CSV.new(File.open(File.join(@file_fixtures, 'articles.csv')),
                headers: true, header_converters: :symbol)
    )
    @journal_csv_doc = JournalCSVDoc.new(
        CSV.new(File.open(File.join(@file_fixtures, 'journals.csv')),
                headers: true, header_converters: :symbol)
    )
    @author_json_doc = AuthorJSONDoc.new(
        JSON.parse(File.open(File.join(@file_fixtures, 'authors.json')).read))
    @combined_documents =
        DocumentsCombined.new(
            @article_csv_doc, @journal_csv_doc, @author_json_doc
        )
  end

  it 'merges articles with their journal and author(s)' do
    required_format = InFormat.output(@a_format, @combined_documents)

    formatted_output = required_format.output_in

    expect(formatted_output).not_to be_empty
  end
end