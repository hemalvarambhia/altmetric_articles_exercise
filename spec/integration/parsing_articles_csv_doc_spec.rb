$LOAD_PATH.unshift '../../lib'
require 'doi'
require 'issn'
require 'article_csv_doc'
require 'altmetric_file'
require 'article_csv_parser'
describe 'Parsing an Articles CSV Doc' do
  it 'parses the DOI, title and ISSN' do
    expected = {
      doi: DOI.new('10.1234/altmetric0'),
      title: 'Small Wooden Chair',
      issn: ISSN.new('1337-8688')
    }
    path_to_csv_doc = File.join(
      File.dirname(__FILE__),'sample_docs','one_article.csv')
    article_csv_doc = ArticleCSVDoc.new(File.open(path_to_csv_doc))
    altmetric_file = AltmetricFile.new(article_csv_doc, ArticleCSVParser)

    expect(altmetric_file.read).to eq expected
  end
end
