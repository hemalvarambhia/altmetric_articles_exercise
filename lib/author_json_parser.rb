require 'article_author'
require 'doi'
class AuthorJSONParser
  def self.parse(author_json)
    ArticleAuthor.new(
      name: author_json['name'],
      publications: author_json['articles'].map { |doi| DOI.new doi }
    )
  end    
end
