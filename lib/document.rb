require 'forwardable'
class Document
  extend Forwardable
  def_delegators :@content, :<<, :empty?

  def initialize(articles = [])
    @content = articles
  end
end
