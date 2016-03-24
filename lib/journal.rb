class Journal
  attr_reader :title, :issn

  def initialize(title, issn)
    @title = title
    @issn = issn
  end

  def ==(other)
    issn == other.issn
  end
end
