require 'forwardable'
require 'doi'
class AuthorJSONDoc
  extend Forwardable
  def_delegator :@content, :empty?

  def initialize content = []
    @content = content
  end

  def find doi
    matching_author = @content.select { |author| published_by?(author, doi) }
    matching_author.collect { |author| author['name'] }
  end

  private

  def published_by?(author, doi)
    publications = author['articles'].collect { |doi| DOI.new(doi) }
    publications.include?(doi)
  end
end