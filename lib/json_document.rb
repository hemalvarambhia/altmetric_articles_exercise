require 'json'
class JSONDocument
  extend Forwardable
  def_delegators :@content, :<<, :empty?
  def initialize(articles = [])
    @content = articles
  end

  def content
    @content.collect { |object| object.as_json }
  end

  def to_s
    JSON.pretty_generate content
  end
end

