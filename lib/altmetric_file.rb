class AltmetricFile
  def initialize(document, parser)
    @io = document
    @parser = parser
  end

  def read
    @parser.parse(@io.read[0])
  end
end
