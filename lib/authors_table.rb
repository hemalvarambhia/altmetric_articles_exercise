class AuthorsTable
  def self.from document
    new document.read
  end

  def initialize(authors = [])
    @authors = authors
  end

  def find(doi)
    author = @authors.select { |author| author.author_of?(doi) }
    author.map { |author| author.name }
  end
end

