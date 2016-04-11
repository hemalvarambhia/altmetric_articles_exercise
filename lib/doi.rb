class DOI
  Malformed = Class.new(Exception)

  def initialize(doi)
    raise Malformed.new if doi.nil? or doi.length == 0
    raise Malformed.new unless doi.start_with? '10.'
    partition = doi.index('/')
    registrant = doi[3..partition - 1]
    raise Malformed.new if registrant.empty?
    object_id = doi[partition + 1..-1]
    raise Malformed.new if object_id.empty?
  end
end

