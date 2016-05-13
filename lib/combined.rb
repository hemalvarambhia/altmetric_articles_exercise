require 'article'
class Combined
  def initialize(articles, journals, authors)
    @articles = articles
    @journals = journals
    @authors = authors
  end

  def output_to document
    @articles.join(@journals, @authors).each do |merged_row|
      document << Article.new(merged_row)
    end
  end
end
