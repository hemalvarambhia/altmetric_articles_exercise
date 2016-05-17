require 'forwardable'
class ArticlesTable
  extend Forwardable
  def_delegator :@rows, :include?

  def self.from document
    new document.read
  end

  def initialize(rows)
    @rows = rows.uniq { |row| row[:doi] }
  end

  def join(journal_table, author_table)
    @rows.collect do |row| 
       row.merge(
         {
           journal: journal_table.find(row[:issn]),
           author: author_table.find(row[:doi])
         }
       )
    end
  end
end

