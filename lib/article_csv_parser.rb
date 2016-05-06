require 'doi'
require 'issn'
class ArticleCSVParser
  def self.parse(row)
    {
      doi: DOI.new(row[0]),
      title: row[1],
      issn: ISSN.new(row[2])
    }
  end
end
