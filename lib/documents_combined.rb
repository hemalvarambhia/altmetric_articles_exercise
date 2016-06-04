class DocumentsCombined
  def initialize(article_csv_doc, journal_csv_doc, author_json_doc)
    @article_csv_doc = article_csv_doc
    @journal_csv_doc = journal_csv_doc
    @author_json_doc = author_json_doc
  end

  def read
    merged = @article_csv_doc.read.collect do |article|
      {
          doi: article.doi,
          title: article.title,
          issn: article.issn,
          journal: @journal_csv_doc.find(article.issn),
          author: @author_json_doc.find(article.doi)
      }
    end

    merged
  end
end
