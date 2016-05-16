class ArticlesTable
  def self.from document
    new document.read
  end

  def initialize(rows)
    @rows = rows
  end

  def join(journal_table, author_table)
    @rows.collect do |row| 
       row.merge(
         {
           journal: journal_table.find(row[:issn]),
           authors: author_table.find(row[:doi])
         }
       )
    end
  end
end

