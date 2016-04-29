class ArticleAuthor
  attr_reader :name, :publications

  def initialize(args)
    @name = args[:name]
    @publications = args.fetch(:publications, []).uniq
  end

  def author_of?(doi)
    @publications.include? doi
  end

  def ==(other)
    return false if name != other.name
    true
  end
end