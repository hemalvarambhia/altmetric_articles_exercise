class DocumentsCombined
  def initialize(article_csv_doc, journal_csv_doc, author_json_doc)
    @article_csv_doc = article_csv_doc
    @journal_csv_doc = journal_csv_doc
    @author_json_doc = author_json_doc
  end

  def read
    merged = @article_csv_doc.read.collect do |row|
      {
          doi: row[:doi],
          title: row[:title],
          issn: row[:issn],
          journal: @journal_csv_doc.find(row[:issn]),
          author: @author_json_doc.find(row[:doi])
      }
    end

    merged
  end
end