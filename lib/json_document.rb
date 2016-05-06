class JSONDocument
  extend Forwardable
  def_delegators :@content, :<<, :empty?
  def initialize(articles = [])
    @content = articles
  end

  def content
    @content.collect { |object| object.as_json }
  end
end

