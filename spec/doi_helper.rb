require 'doi'
module CreateDOI
  def a_doi
    registrant = Array.new(4) { rand(0..9) }.join
    DOI.new("10.#{registrant}/altmetric#{rand(100000000)}")
  end
end