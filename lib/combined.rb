class Combined
  def initialize(articles, journals, authors)
    @articles = articles
    @journals = journals
    @authors = authors
  end

  def output_to document
     document << OpenStruct.new(@articles.join(@journals, @authors))
  end
end