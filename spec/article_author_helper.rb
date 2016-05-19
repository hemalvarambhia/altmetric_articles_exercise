require 'article_author'
module CreateAuthor  
  def an_author(args)
    ArticleAuthor.new args
  end
end
