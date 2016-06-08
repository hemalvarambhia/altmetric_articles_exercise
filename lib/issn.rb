require 'forwardable'
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

  def ==(other)
    return code == other unless other.class == ISSN

    code == other.code
  end

  def eql?(other)
    code.eql?(other.code)
  end

  def to_s
    code
  end

  private

  def dash_missing?(code)
    code.scan(/-/).none?
  end
end
