require 'doi'
require 'issn'
class ArticleCSVParser
  def self.parse(row)
    {
      doi: DOI.new(row.first),
      title: row[1],
      issn: ISSN.new(row.last)
    }
  end
end
