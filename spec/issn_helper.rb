require 'issn'
module CreateISSN
  def an_issn
    code = Array.new(8) { rand(0..9) }
    issn "#{code.join}"
  end

  def issn(code)
    ISSN.new(code)
  end

  def generate_issn
    digits = Array.new(8) { rand(0..9) }
    "#{digits[0..3].join}-#{digits[4..-1].join}"
  end
end
