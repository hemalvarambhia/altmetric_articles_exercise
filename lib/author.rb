class Author
  attr_reader :name, :publications

  def initialize(args)
    @name = args[:name]
    @publications = args.fetch(:publications, [])
  end

  def author_of?(doi)
    @publications.include? doi
  end
end