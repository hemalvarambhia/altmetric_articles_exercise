class ISSN
  extend Forwardable
  def_delegator :@code, :hash
  attr_reader :code

  class Malformed < Exception
    def initialize(code)
      message = "The ISSN '#{code}' is malformed. "
      message << "ISSNs take the form \d{4}-\d{4} e.g. '0317-8471'"
      super message
    end
  end
    
  def initialize(code)
    raise Malformed.new(code) if (code=~/^\d{4}-?\d{4}$/).nil?      
    @code = code
    @code = code.insert(4, '-') if code.scan(/-/).none?
  end

  def ==(other)
    code == other.code
  end

  def to_s
    code
  end
end
