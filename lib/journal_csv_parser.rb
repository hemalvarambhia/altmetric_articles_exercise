require 'issn'
class JournalCSVParser
  def self.parse(row)
    [ ISSN.new(row[1]), row[0] ]
  end
end
