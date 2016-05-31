require 'issn'
module CreateISSN
  def generate_issn
    digits = Array.new(8) { rand(0..9) }
    "#{digits[0..3].join}-#{digits[4..-1].join}"
  end
end
