class ArticlesTable
  def self.from(file)
    new(file.read)
  end

  def initialize(row)
    @row = row
  end

  def join(journal_table, author_table)
    @row.merge(
        {
            journal: journal_table.find(@row[:issn]),
            authors: author_table.find(@row[:doi])
        }
    )
  end
end

