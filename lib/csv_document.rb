class CSVDocument
  extend Forwardable
  def_delegators :@content, :<<, :empty?

  def initialize(object = nil)
    @content = [ object ].compact
  end

  def content
    @content.collect { |object| object.as_csv }
  end
end

