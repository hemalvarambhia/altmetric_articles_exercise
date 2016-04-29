class ArticleAuthor
  attr_reader :name, :publications

  def initialize(args)
    @name = args[:name]
    @publications = args.fetch(:publications, []).uniq
  end

  def author_of?(doi)
    @publications.include? doi
  end
end