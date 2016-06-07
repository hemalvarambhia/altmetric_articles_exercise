require 'issn'
require 'forwardable'
class ArticleCSVDoc
  extend Forwardable
  include ISSN
  def_delegator :@rows, :empty?

  def initialize content = []
    @rows = Array.new(
      content.collect do |row|
        OpenStruct.new(
          doi: row[:doi], title: row[:title], issn: to_issn(row[:issn])
        )
      end
    )
  end

  def read
    @rows
  end
end
