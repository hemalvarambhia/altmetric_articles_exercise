require 'json'
require 'forwardable'
class JSONDocument
  extend Forwardable
  def_delegators :@content, :<<, :empty?
  attr_reader :content
  def initialize(articles = [])
    @content = articles
  end

  def to_s
    JSON.pretty_generate content
  end
end

