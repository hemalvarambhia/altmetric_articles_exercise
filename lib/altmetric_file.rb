class AltmetricFile
  def initialize(document, parser)
    @io = document
    @parser = parser
  end

  def read
    @io.read.collect{ |object| @parser.parse(object) }
  end
end
