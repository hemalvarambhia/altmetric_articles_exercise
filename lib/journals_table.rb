class JournalsTable
  def self.from document
    new document.read
  end

  def initialize(*rows)
    @journals = Hash[rows]
  end

  def find(issn)
    @journals[issn]
  end
end
