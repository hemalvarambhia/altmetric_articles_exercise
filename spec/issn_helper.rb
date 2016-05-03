require 'issn'
module CreateISSN
  def an_issn
    code = Array.new(8) { rand(0..9) }
    ISSN.new "#{code.join}"
  end
end