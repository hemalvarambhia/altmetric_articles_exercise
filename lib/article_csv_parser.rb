require 'doi'
require 'issn'
class ArticleCSVParser
  def self.parse row
    issn = row[:issn]
    corrected_issn = has_dash?(issn) ? issn : issn.insert(4, '-')
    { doi: row[:doi], title: row[:title], issn: corrected_issn }
  end

  private

  def self.has_dash?(issn)
    issn.index('-')
  end
end
