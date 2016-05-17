require 'csv'
require 'forwardable'
class CSVDocument
  extend Forwardable
  def_delegators :@content, :<<, :empty?

  def initialize(rows = [])
    @content = rows
  end

  def content
    @content.collect do |object|
      [
          object[:doi],
          object[:title],
          object.fetch(:author, []).join(', '),
          object[:journal],
          object[:issn]
      ]
    end
  end

  def to_s
    CSV.generate do |csv|
      content.each { |row| csv << row }
    end
  end
end

