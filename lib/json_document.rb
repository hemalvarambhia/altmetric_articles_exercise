require 'json'
require 'forwardable'
class JSONDocument
  extend Forwardable
  def_delegators :@content, :<<, :empty?
  attr_reader :content
  def initialize(articles = [])
    @content = articles
  end

  def content
    @content.collect do |article|
      {
          doi: article[:doi],
          title: article[:title],
          author: article.fetch(:author, []).join(', '),
          journal: article[:journal],
          issn: article[:issn]
      }
    end
  end

  def to_s
    JSON.pretty_generate content
  end
end

