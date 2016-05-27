require 'issn'
module CreateISSN
  def an_issn
    code = Array.new(8) { rand(0..9) }
    issn "#{code.join}"
  end

  def issn(code)
    ISSN.new(code)
  end
end