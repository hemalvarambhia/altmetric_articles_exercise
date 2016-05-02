class DOI
  extend Forwardable
  def_delegator :@serial_code, :hash
  attr_reader :serial_code

  Malformed = Class.new(Exception)

  def initialize(doi)
    raise Malformed.new if doi.nil? or doi.length == 0
    raise Malformed.new unless doi.start_with? '10.'
    partition = doi.index('/')
    registrant = doi[3..partition - 1]
    raise Malformed.new if registrant.empty?
    object_id = doi[partition + 1..-1]
    raise Malformed.new if object_id.empty?
    @serial_code = doi    
  end

  def == other
    serial_code == other.serial_code
  end

  def to_s
    serial_code
  end
end

