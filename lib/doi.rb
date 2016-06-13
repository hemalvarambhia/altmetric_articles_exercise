class DOI
  attr_reader :code

  def initialize(code)
    raise Malformed.new(code) if code.nil?
    registry = code[0..2]
    raise Malformed.new(code) unless registry == '10.'
    separator = code.index('/')
    registrant = code[3..separator - 1]
    raise Malformed.new(code) if registrant.empty?
    item_id = code[separator + 1..-1]
    raise Malformed.new(code) if item_id.empty?
    @code = code
  end

  def ==(other)
    return code == other unless other.class == DOI

    code == other.code
  end

  def to_s
    code
  end

  class Malformed < Exception
    def initialize(doi)
      super "DOI '#{doi}' is malformed"
    end
  end
end