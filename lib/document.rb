require 'forwardable'
class Document
  extend Forwardable
  def_delegators :@content, :<<, :include?, :[], :empty?

  def initialize(articles = [])
    @content = articles
  end
end
