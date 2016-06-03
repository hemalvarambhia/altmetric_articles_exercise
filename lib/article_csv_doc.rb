require 'issn'
require 'forwardable'
class ArticleCSVDoc
  extend Forwardable
  include ISSN
  def_delegator :@rows, :empty?

  def initialize content = []
    @rows = content.collect do |row|
      { doi: row[:doi], title: row[:title], issn: correct_issn(row[:issn]) }
    end
  end

  def read
    @rows
  end
end