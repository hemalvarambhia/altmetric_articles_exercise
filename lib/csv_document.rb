require 'csv'
require 'forwardable'
class CSVDocument
  extend Forwardable
  def_delegators :@content, :<<, :empty?

  def initialize(object = nil)
    @content = [ object ].compact
  end

  def content
    @content.collect { |object| object.values }
  end

  def to_s
    CSV.generate do |csv|
      content.each { |row| csv << row }
    end
  end
end

