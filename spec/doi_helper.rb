require 'doi'
module CreateDOI
  def a_doi
    registrant = Array.new(4) { rand(0..9) }.join
    doi("10.#{registrant}/altmetric#{rand(100000000)}")
  end

  def doi(code)
    DOI.new(code)
  end

  def generate_doi
    registrant = Array.new(4) { rand(0..9) }.join
    "10.#{registrant}/altmetric#{rand(100000000)}"
  end  
end
