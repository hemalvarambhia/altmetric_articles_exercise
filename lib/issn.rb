module ISSN
  def correct_issn(issn)
    dash_absent = issn.scan(/-/).none?
    corrected = dash_absent ? issn.insert(4, '-') : issn

    corrected
  end

  class ISSN
    extend Forwardable
    def_delegators :@code, :hash
    attr_reader :code

    Malformed = Class.new(Exception)
    def initialize(code)
      raise Malformed.new("ISSN '#{code}' is malformed") unless code=~/^\d{4}-?\d{4}$/
      @code = code
      @code = code.insert(4, '-') if dash_missing?(code)
    end

    def dash_missing?(code)
      code.scan(/-/).none?
    end

    def ==(other)
      return code == other unless other.class == ISSN

      code == other.code
    end

    def eql?(other)
      code.eql?(other.code)
    end
  end
end
